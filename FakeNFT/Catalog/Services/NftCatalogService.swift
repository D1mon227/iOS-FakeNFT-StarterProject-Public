import Foundation

extension NftCatalogService {
    enum NftCatalogServiceError: Error {
        case parseError, networkError
    }
}

protocol NftCatalogServiceProtocol {
    func getNftItems(completion: @escaping (Result<[NftCodable], Error>) -> Void)
}

final class NftCatalogService: NftCatalogServiceProtocol {
    static let shared = NftCatalogService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private(set) var nftItem: NftCodable?
    
    private let urlString = ""
    
    internal func getNftItems(completion: @escaping (Result<[NftCodable], Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
//        let session = urlSession
//        let task = session.objectTask(for: ) { [weak self] (result: Result<NftCodable, Error>) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let nftItemResult):
//                completion(.success(self.nftItem ?? NftCodable))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//            self.task = nil
//        }
//        self.task = task
//        task.resume()
    }
}
