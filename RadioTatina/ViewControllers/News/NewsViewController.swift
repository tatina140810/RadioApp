import UIKit
import Combine

class NewsViewController: UIViewController {
    
    private let viewModel = NewsViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let newsLabel: UILabel = {
        let label = UILabel()
        label.text = "Новости сегодня"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor(hex: "#000000")
        return label
    }()
    
    private lazy var verticalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 328, height: 164)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        viewModel.fetchNews()
    }

    private func setupUI() {
        verticalCollectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        verticalCollectionView.delegate = self
        verticalCollectionView.dataSource = self

        view.addSubview(newsLabel)
        view.addSubview(verticalCollectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyLabel)

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        verticalCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)


        newsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }

        verticalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(newsLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    private func bindViewModel() {
        viewModel.$news
            .receive(on: RunLoop.main)
            .sink { [weak self] news in
                self?.verticalCollectionView.reloadData()
                self?.emptyLabel.isHidden = !news.isEmpty
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

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет новостей"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private let refreshControl = UIRefreshControl()
    
    @objc private func refreshNews() {
        viewModel.fetchNews()
    }


}

// MARK: - UICollectionViewDataSource & Delegate
extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.news.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }

        let item = viewModel.news[indexPath.item]
        cell.configure(title: item.title, subtitle: item.content, imageURL: item.image)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = viewModel.news[indexPath.item]
        let detailVC = NewsDetailViewController(newsItem: selected)
        present(detailVC, animated: true)
    }
}
