import Foundation
import Moya

struct News: Decodable {
    let id: Int
    let title: String
    let content: String
    let image: String?
    let created_at: String?
}

struct AdModel: Decodable {
    let id: Int
    let title: String
    let description: String
    let image: String?
    let category: String
    let createdAt: String?
    let isApproved: Bool
}

final class NetworkManager {
    static let shared = NetworkManager()

    private let provider = MoyaProvider<AdminApi>(plugins: [NetworkLoggerPlugin()])
    private init() {}

    func fetchNews(completion: @escaping (Result<[News], Error>) -> Void) {
        provider.request(.getNews) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func createNews(title: String, content: String, imageData: Data?, completion: @escaping (Result<News, Error>) -> Void) {
        provider.request(.createNews(title: title, content: content, imageData: imageData)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func updateNews(id: Int, title: String, content: String, imageData: Data?, completion: @escaping (Result<News, Error>) -> Void) {
        provider.request(.updateNews(id: id, title: title, content: content, imageData: imageData)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func deleteNews(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.deleteNews(id: id)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchAds(category: AdCategory? = nil, completion: @escaping (Result<[AdModel], Error>) -> Void) {
        let adjustedCategory = (category == .all) ? nil : category
        
        provider.request(.getAds(category: adjustedCategory)) { result in
            self.handleResponse(result, completion: completion)
        }
    }


    func createAd(title: String, description: String, category: AdCategory, imageData: Data?, completion: @escaping (Result<AdModel, Error>) -> Void) {
        provider.request(.createAd(title: title, description: description, category: category, imageData: imageData)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func updateAd(id: Int, title: String, description: String, category: AdCategory, imageData: Data?, completion: @escaping (Result<AdModel, Error>) -> Void) {
        provider.request(.updateAd(id: id, title: title, description: description, category: category, imageData: imageData)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func deleteAd(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.deleteAd(id: id)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func handleResponse<T: Decodable>(_ result: Result<Response, MoyaError>, completion: @escaping (Result<T, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(T.self, from: response.data)
                completion(.success(decoded))
            } catch {
                print("❌ Decode error:", error)
                completion(.failure(error))
            }
        case .failure(let error):
            print("❌ Network error:", error)
            completion(.failure(error))
        }
    }
}
