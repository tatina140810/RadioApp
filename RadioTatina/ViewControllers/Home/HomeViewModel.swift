import Foundation
import AVFoundation
import Combine

final class HomeViewModel {
    @Published var songTitle: String = "Название песни"
    @Published var artistTitle: String = "Исполнитель"
    @Published var isPlaying: Bool = false

    private var player: AVPlayer?
    private var metadataTimer: Timer?
    
    private let streamURL = URL(string: "https://s0.radioheart.ru:8000/RH78517")!
    private let metadataURL = URL(string: "https://s0.radioheart.ru:8000/json.xsl?mount=/RH78517")!

    init() {
        setupAudioSession()
        startMetadataTimer()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlaybackStall),
            name: .AVPlayerItemPlaybackStalled,
            object: nil
        )
    }

    deinit {
        metadataTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }

    func togglePlayback() {
        if isPlaying {
            player?.pause()
            isPlaying = false
        } else {
            player = AVPlayer(url: streamURL)
            player?.play()
            isPlaying = true
        }
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудио сессии: \(error.localizedDescription)")
        }
    }

    @objc private func handlePlaybackStall() {
        isPlaying = false
    }

    private func startMetadataTimer() {
        fetchMetadata()
        metadataTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            self?.fetchMetadata()
        }
    }

    private func fetchMetadata() {
        URLSession.shared.dataTask(with: metadataURL) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Ошибка загрузки метаданных: \(error?.localizedDescription ?? "неизвестно")")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let mounts = json["mounts"] as? [[String: Any]], !mounts.isEmpty {

                    let info = mounts[0]
                    let song = info["title"] as? String ?? "Unknown Song"
                    let artist = song.split(separator: "-").first?.trimmingCharacters(in: .whitespaces) ?? "Unknown Artist"

                    DispatchQueue.main.async {
                        self?.songTitle = song
                        self?.artistTitle = artist
                    }
                }
            } catch {
                print("Ошибка парсинга JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
