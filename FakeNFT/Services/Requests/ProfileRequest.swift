import Foundation

enum ProfileRequest: NetworkRequest {
    
    case getProfileById(id: String)
    case putProfile(user: ProfileModel)
    
    var endpoint: URL? {
        switch self {
        case .getProfileById(let id):
            return URL(string: "\(baseURL)/api/v1/profile/\(id)")
        case .putProfile(let user):
            return makeURLWithParams(id: user.id)
        }
    }
    
    var baseURL: String {
        return "https://64858e8ba795d24810b71189.mockapi.io"
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getProfileById:
            return .get
        case .putProfile:
            return .put
        }
    }
    
    var params: [URLQueryItem] {
        switch self {
        case .getProfileById:
            return []
        case .putProfile(let user):
            return [
                URLQueryItem(name: "name", value: user.name),
                URLQueryItem(name: "likes", value: user.likes.joined(separator: ",")),
                URLQueryItem(name: "website", value: user.website.absoluteString),
                URLQueryItem(name: "description", value: user.description)
            ]
        }
    }
    
    private func makeURLWithParams(id: String) -> URL? {
        guard let url = URL(string: "\(baseURL)/api/v1/profile/\(id)") else { return nil }
        var urlComponents = URLComponents(url: url,
                                          resolvingAgainstBaseURL: true)

        // Добавляем параметры к URL
        urlComponents?.queryItems = self.params
        
        return urlComponents?.url
    }
}

