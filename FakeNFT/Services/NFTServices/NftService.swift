//
//  NftService.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 08.08.2023.
//

import Foundation

extension NftService {
    enum NftServiceError: Error {
        case parseError, networkError, notEnoughDataForRequest
    }
}

protocol NftServiceProtocol {
    func getNft(by id: String, completion: @escaping (Result<NftResponse, Error>) -> Void)
}

final class NftService: NftServiceProtocol {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func getNft(by id: String, completion: @escaping (Result<NftResponse, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let session = urlSession
        let modelRequest = NftRequest.getNftById(id: id)
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        let task = session.objectTask(for: request) { [weak self] (result: Result<NftResponse, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let nftItemResult):
                    completion(.success(nftItemResult))
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
            throw NftServiceError.notEnoughDataForRequest
        }
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = networkRequestModel.httpMethod.rawValue
        return urlRequest
    }
 }




