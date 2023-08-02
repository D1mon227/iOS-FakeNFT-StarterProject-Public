import Foundation

extension NftCatalogService {
    enum NftCatalogServiceError: Error {
        case parseError, networkError, notEnoughDataForRequest
    }
}

protocol NftCatalogServiceProtocol {
    func getNftItems(completion: @escaping (Result<[NftResponse], Error>) -> Void)
}

final class NftCatalogService: NftCatalogServiceProtocol {    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private let urlString = ""
    
    func getNftItems(completion: @escaping (Result<[NftResponse], Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let session = urlSession
        let modelRequest = NftCollectionRequest.getAllCollections
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        let task = session.objectTask(for: request) { [weak self] (result: Result<[NftResponse], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let nftItemResult):
                completion(.success(nftItemResult))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(for networkRequestModel: NetworkRequest) throws -> URLRequest {
        guard let endpoint = networkRequestModel.endpoint else {
           // написать ошибку
            throw NftCatalogServiceError.notEnoughDataForRequest
        }
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = networkRequestModel.httpMethod.rawValue
        return urlRequest
    }
 }


