import Foundation

extension NftCatalogService {
    enum NftCatalogServiceError: Error {
        case parseError, networkError, notEnoughDataForRequest
    }
}

protocol NftCatalogServiceProtocol {
    func getNftItems(completion: @escaping (Result<[NftCollectionResponse], Error>) -> Void)
}

final class NftCatalogService: NftCatalogServiceProtocol {
    private let urlSession = URLSession.shared
    
    func getNftItems(completion: @escaping (Result<[NftCollectionResponse], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let session = urlSession
        let modelRequest = NftCollectionRequest.getAllCollections
        
        do {
            let request = try makeRequest(for: modelRequest)
            session.objectTask(for: request) { (result: Result<[NftCollectionResponse], Error>) in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let nftItemResult):
                        completion(.success(nftItemResult))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch {
            print("Failed")
        }
    }
    
    private func makeRequest(for networkRequestModel: NetworkRequest) throws -> URLRequest {
        guard let endpoint = networkRequestModel.endpoint else {
            throw NftCatalogServiceError.notEnoughDataForRequest
        }
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = networkRequestModel.httpMethod.rawValue
        return urlRequest
    }
 }




