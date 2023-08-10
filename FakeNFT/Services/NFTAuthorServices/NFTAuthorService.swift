import Foundation

extension NFTAuthorService {
    enum NFTAuthorServiceError: Error {
        case parseError, networkError, notEnoughDataForRequest
    }
}

protocol NFTAuthorServiceProtocol {
    func getNftAuthor(by id: String,
                     completion: @escaping (Result<AuthorResponse, Error>) -> Void)
}

final class NFTAuthorService: NFTAuthorServiceProtocol {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func getNftAuthor(by id: String,
                      completion: @escaping (Result<AuthorResponse, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let session = urlSession
        let modelRequest = AuthorRequest.getProfileById(id: id)
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        let task = session.objectTask(for: request) { [weak self] (result: Result<AuthorResponse, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let authorResult):
                    completion(.success(authorResult))
                case .failure(let error):
                    completion(.failure(error))
                }
            }

            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(for networkRequestModel: NetworkRequest) throws -> URLRequest {
        guard let endpoint = networkRequestModel.endpoint else {
            throw NFTAuthorServiceError.notEnoughDataForRequest
        }
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = networkRequestModel.httpMethod.rawValue
        return urlRequest
    }
 }



