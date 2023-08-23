import Foundation

final class NFTCollectionService {
    static let shared = NFTCollectionService()
    private let networkClient = DefaultNetworkClient()
    
    func fetchNFTCollections(completion: @escaping (Result<[NFTCollection], Error>) -> Void) {
        
        UIBlockingProgressHUD.show()
        let request = NFTCollectionRequest(httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: [NFTCollection].self) { result in
            switch result {
            case .success(let collection):
                completion(.success(collection))
            case .failure(let error):
                completion(.failure(error))
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
