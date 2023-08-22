import Foundation

final class NFTService {
    static let shared = NFTService()
    private let networkClient = DefaultNetworkClient()
    
    func fetchNFT(completion: @escaping (Result<[NFT], Error>) -> Void) {
        
        UIBlockingProgressHUD.show()
        let request = NFTsRequest(httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: [NFT].self) { result in
            switch result {
            case .success(let nfts):
                completion(.success(nfts))
            case .failure(let error):
                completion(.failure(error))
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
