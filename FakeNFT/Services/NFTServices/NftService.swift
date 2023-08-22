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
    
    func getNft(by id: String, completion: @escaping (Result<NftResponse, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let session = urlSession
        let modelRequest = NftRequest.getNftById(id: id)
        
        do {
            let request = try makeRequest(for: modelRequest)
            session.objectTask(for: request) { (result: Result<NftResponse, Error>) in
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
            //обработать ошибку
        }

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






