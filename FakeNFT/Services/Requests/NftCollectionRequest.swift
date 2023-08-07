
import Foundation

enum NftCollectionRequest: NetworkRequest {
    
    case getCollectionById(id: Int)
    case getAllCollections
    
    var endpoint: URL? {
        switch self {
        case .getCollectionById(let id):
            return URL(string: "\(baseURL)/api/v1/collections/\(id)")
        case .getAllCollections:
            return URL(string: "\(baseURL)/api/v1/collections")
        }
       
    }
    
    var baseURL: String {
        return "https://64858e8ba795d24810b71189.mockapi.io"
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getCollectionById, .getAllCollections:
            return .get
        }
    }
}

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
