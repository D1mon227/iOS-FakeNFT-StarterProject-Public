import Foundation

final class UserService {
    static let shared = UserService()
    private let networkClient = DefaultNetworkClient()
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        
        UIBlockingProgressHUD.show()
        let request = UsersRequest(httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: [User].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
