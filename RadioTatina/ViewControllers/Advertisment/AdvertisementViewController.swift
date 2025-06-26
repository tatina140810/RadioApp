import UIKit
import Combine

class AdvertisementViewController: UIViewController, UISearchResultsUpdating {
    
    private let viewModel = AdvertisementViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let categories: [AdCategory] = [.all, .realEstate, .transport, .services, .jobs]
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Поиск объявлений"
        return controller
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет объявлений"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let refreshControl = UIRefreshControl()
    
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 35)
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var verticalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 328, height: 164)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#2CA334")
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 30
        button.tintColor = .white
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(horizontalCollectionView)
        view.addSubview(verticalCollectionView)
        view.addSubview(addButton)
        view.addSubview(activityIndicator)
        view.addSubview(emptyLabel)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        verticalCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshADS), for: .valueChanged)
        
        
        horizontalCollectionView.register(ButtonsCell.self, forCellWithReuseIdentifier: ButtonsCell.identifier)
        verticalCollectionView.register(AdvertismentCell.self, forCellWithReuseIdentifier: AdvertismentCell.identifier)
        
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        verticalCollectionView.delegate = self
        verticalCollectionView.dataSource = self
        
        horizontalCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        verticalCollectionView.snp.makeConstraints {
            $0.top.equalTo(horizontalCollectionView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-100)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(60)
        }
    }
    
    private func bindViewModel() {
        
        viewModel.$filteredAds
            .receive(on: RunLoop.main)
            .sink { [weak self] ads in
                self?.verticalCollectionView.reloadData()
                self?.emptyLabel.isHidden = !ads.isEmpty
            }
            .store(in: &cancellables)
        
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func refreshADS() {
        viewModel.fetchAds(for: viewModel.selectedCategory)
    }
    
    
    @objc private func addButtonTapped() {
        let vc = AddAdvertisment()
        navigationController?.present(vc, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension AdvertisementViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == horizontalCollectionView ? categories.count : viewModel.filteredAds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonsCell.identifier, for: indexPath) as? ButtonsCell else {
                return UICollectionViewCell()
            }
            let category = categories[indexPath.item]
            let isSelected = viewModel.selectedCategory == category
            cell.configure(with: category, isSelected: isSelected)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertismentCell.identifier, for: indexPath) as? AdvertismentCell else {
                return UICollectionViewCell()
            }
            let ad = viewModel.filteredAds[indexPath.item]
            cell.titleLabel.text = ad.title
            cell.descriptionLabel.text = ad.description
            if let imageUrl = ad.image, let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.adImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            } else {
                cell.adImageView.image = nil
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == horizontalCollectionView {
            let selected = categories[indexPath.item]
            guard selected != viewModel.selectedCategory else { return }
            viewModel.selectedCategory = selected
            horizontalCollectionView.reloadData()
        } else {
            let selectedAd = viewModel.filteredAds[indexPath.item]
            let detailVC = OpenCardViewController(ad: selectedAd)
            present(detailVC, animated: true)
        }
    }
}
