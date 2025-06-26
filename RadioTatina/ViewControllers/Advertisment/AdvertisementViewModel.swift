import Foundation
import Combine

final class AdvertisementViewModel {
    @Published var ads: [AdModel] = []
    @Published var filteredAds: [AdModel] = []
    @Published var selectedCategory: AdCategory = .all
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false  
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        Publishers.CombineLatest($ads, $searchText)
            .map { ads, text in
                guard !text.isEmpty else { return ads }
                return ads.filter {
                    $0.title.lowercased().contains(text.lowercased()) ||
                    $0.description.lowercased().contains(text.lowercased())
                }
            }
            .assign(to: \.filteredAds, on: self)
            .store(in: &cancellables)
        
        $selectedCategory
            .removeDuplicates()
            .sink { [weak self] category in
                self?.fetchAds(for: category)
            }
            .store(in: &cancellables)
    }
    
    func fetchAds(for category: AdCategory) {
        isLoading = true
        
        let adjusted = category == .all ? nil : category
        NetworkManager.shared.fetchAds(category: adjusted) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ads):
                    self?.ads = ads.filter { $0.isApproved }
                case .failure(let error):
                    print("❌ Ошибка загрузки: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func refreshAds() {
        fetchAds(for: selectedCategory)
    }
}
