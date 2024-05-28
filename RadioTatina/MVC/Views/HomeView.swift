import UIKit
import SnapKit
import AVFoundation

class HomeView: UIViewController, AVAudioPlayerDelegate {
    
    private lazy var navigationBarView: CustomNavigationBarInMuzicPage = {
        let view = CustomNavigationBarInMuzicPage()
        return view
    }()
    
    private lazy var titleImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .tatinaLogo)
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor(hex: "039139")
        button.layer.cornerRadius = 35
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        view.addSubview(titleImage)
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView).offset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(300)
        }
        
        view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
    }
    
    var player: AVPlayer?
    
    private func setupPlayer() {
        guard let url = URL(string: "http://82.146.46.229:8000/radio.mp3") else {
            return
        }
        player = AVPlayer(url: url)
    }
    
    @objc func playButtonTapped(_ sender: UIButton) {
        if player == nil {
            setupPlayer()
        }
        player?.play()
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        player?.pause()
    }
    
    func audioPlayerDidFinishPlaying(_ audioPlayer: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Длительность музыки: \(audioPlayer.duration) секунд")
        } else {
            print("Воспроизведение музыки завершилось неудачно.")
        }
    }
}
