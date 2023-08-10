import Foundation

enum AuthorRequest: NetworkRequest {
    
    case getProfileById(id: String)
    case putProfileById(id: String)
    
    var endpoint: URL? {
        switch self {
        case .getProfileById(let id):
            return URL(string: "\(baseURL)/api/v1/profile/\(id)")
        case .putProfileById(let id):
            return URL(string: "\(baseURL)/api/v1/profile/\(id)")
        }
       
    }
    
    var baseURL: String {
        return "https://64858e8ba795d24810b71189.mockapi.io"
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getProfileById:
            return .get
        case .putProfileById:
            return .put
        }
    }
}
