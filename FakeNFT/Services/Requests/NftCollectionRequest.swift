
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

enum NftRequest: NetworkRequest {
    
    case getNftById(id: String)
    
    var endpoint: URL? {
        switch self {
        case .getNftById(let id):
            return URL(string: "\(baseURL)/api/v1/nft/\(id)")
        }
       
    }
    
    var baseURL: String {
        return "https://64858e8ba795d24810b71189.mockapi.io"
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getNftById:
            return .get
        }
    }
}
