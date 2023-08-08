import Foundation

final class LikeService {
    static let shared = LikeService()
    private let networkClient = DefaultNetworkClient()
    
    func changeLike(newLike: Like, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        UIBlockingProgressHUD.show()
        let request = ProfileRequest(httpMethod: .put, dto: newLike)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
