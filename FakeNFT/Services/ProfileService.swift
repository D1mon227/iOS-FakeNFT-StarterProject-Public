import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let networkClient = DefaultNetworkClient()
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        
        UIBlockingProgressHUD.show()
        let request = ProfileRequest(httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func editProfile(newProfile: NewProfile, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        UIBlockingProgressHUD.show()
        let request = ProfileRequest(httpMethod: .put, dto: newProfile)
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
