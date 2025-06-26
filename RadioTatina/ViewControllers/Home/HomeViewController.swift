import UIKit
import SnapKit
import Combine

class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .logo)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private let songTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let artistTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGreen
        button.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-110)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(65)
        }

        view.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }

        view.addSubview(songTitle)
        songTitle.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        view.addSubview(artistTitle)
        artistTitle.snp.makeConstraints { make in
            make.top.equalTo(songTitle.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.$songTitle
            .receive(on: RunLoop.main)
            .sink { [weak self] title in
                self?.songTitle.text = title
            }
            .store(in: &cancellables)

        viewModel.$artistTitle
            .receive(on: RunLoop.main)
            .sink { [weak self] artist in
                self?.artistTitle.text = artist
            }
            .store(in: &cancellables)
        viewModel.$isPlaying
            .receive(on: RunLoop.main)
            .sink { [weak self] isPlaying in
                let icon = isPlaying ? "pause.circle.fill" : "play.circle.fill"
                self?.playButton.setBackgroundImage(UIImage(systemName: icon), for: .normal)
            }
            .store(in: &cancellables)
    }

    @objc private func playButtonTapped() {
        viewModel.togglePlayback()
    }
}
