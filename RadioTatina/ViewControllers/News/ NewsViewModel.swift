import Foundation
import Combine

final class NewsViewModel {
    @Published var news: [News] = []
    @Published var isLoading: Bool = false

    func fetchNews() {
        isLoading = true
        NetworkManager.shared.fetchNews { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newsList):
                    self?.news = newsList
                case .failure(let error):
                    print("❌ Ошибка загрузки новостей: \(error.localizedDescription)")
                }
            }
        }
    }
}
