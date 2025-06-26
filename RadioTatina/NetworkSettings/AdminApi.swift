import Moya

enum AdCategory: String, CaseIterable, Equatable {
    case all
    case realEstate = "real_estate"
    case transport
    case services
    case jobs

    var displayName: String {
        switch self {
        case .all: return "Все"
        case .realEstate: return "Недвижимость"
        case .transport: return "Транспорт"
        case .services: return "Услуги"
        case .jobs: return "Работа"
        }
    }
}
enum AdminApi {
    case getNews
    case createNews(title: String, content: String, imageData: Data?)
    case updateNews(id: Int, title: String, content: String, imageData: Data?)
    case deleteNews(id: Int)
    case getAds(category: AdCategory?)
    case createAd(title: String, description: String, category: AdCategory, imageData: Data?)
    case updateAd(id: Int, title: String, description: String, category: AdCategory, imageData: Data?)
    case deleteAd(id: Int)
}

extension AdminApi: TargetType {
    var baseURL: URL {
       return URL(string: "https://tatina-radio.space/api")!
    }

    var path: String {
        switch self {
        case .getNews, .createNews:
            return "/news/"
        case .updateNews(let id, _, _, _), .deleteNews(let id):
            return "/news/\(id)/"
        case .getAds, .createAd:
            return "/ads/"
        case .updateAd(let id, _, _, _, _), .deleteAd(let id):
            return "/ads/\(id)/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getNews, .getAds:
            return .get
        case .createNews, .createAd:
            return .post
        case .updateNews, .updateAd:
            return .put
        case .deleteNews, .deleteAd:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .getNews:
            return .requestPlain

        case .getAds(let category):
            if let category = category, category != .all {
                return .requestParameters(parameters: ["category": category.rawValue], encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }
        case .createNews(let title, let content, let imageData),
             .updateNews(_, let title, let content, let imageData):
            var multipart: [MultipartFormData] = [
                MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title"),
                MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content")
            ]
            if let imageData = imageData {
                multipart.append(
                    MultipartFormData(provider: .data(imageData),
                                      name: "image",
                                      fileName: "news.jpg",
                                      mimeType: "image/jpeg")
                )
            }
            return .uploadMultipart(multipart)

        case .createAd(let title, let description, let category, let imageData),
             .updateAd(_, let title, let description, let category, let imageData):
            var multipartData: [MultipartFormData] = [
                MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title"),
                MultipartFormData(provider: .data(description.data(using: .utf8)!), name: "description"),
                MultipartFormData(provider: .data(category.rawValue.data(using: .utf8)!), name: "category")
            ]
            if let imageData = imageData {
                multipartData.append(
                    MultipartFormData(provider: .data(imageData),
                                      name: "image",
                                      fileName: "ad.jpg",
                                      mimeType: "image/jpeg")
                )
            }
            return .uploadMultipart(multipartData)

        case .deleteNews, .deleteAd:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .createNews, .updateNews, .createAd, .updateAd:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
