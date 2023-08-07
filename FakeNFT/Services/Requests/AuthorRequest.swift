import Foundation

enum AuthorRequest: NetworkRequest {
    
    case getAuthorById(id: String)
    
    var endpoint: URL? {
        switch self {
        case .getAuthorById(let id):
            return URL(string: "\(baseURL)/api/v1/profile/\(id)")
        }
       
    }
    
    var baseURL: String {
        return "https://64858e8ba795d24810b71189.mockapi.io"
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getAuthorById:
            return .get
        }
    }
}
