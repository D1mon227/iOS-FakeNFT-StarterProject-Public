//
//  FavoriteNftsService.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 10.08.2023.
//

import Foundation

extension ProfileService {
    enum FavoriteNftsServiceError: Error {
        case parseError, networkError, notEnoughDataForRequest
    }
}

protocol ProfileServiceProtocol {
    func getNft(by id: String, completion: @escaping (Result<NftResponse, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    private let urlSession = URLSession.shared
    private let authId = "1"
    
    func getProfile(completion: @escaping (Result<NftResponse, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let session = urlSession
        let modelRequest = AuthorRequest.getProfileById(id: authId)
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        session.objectTask(for: request) { [weak self] (result: Result<NftResponse, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let nftItemResult):
                    completion(.success(nftItemResult))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()

    }
    
    func putProfile(completion: @escaping (Result<NftResponse, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let session = urlSession
        let modelRequest = AuthorRequest.getProfileById(id: authId)
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        session.objectTask(for: request) { [weak self] (result: Result<NftResponse, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let nftItemResult):
                    completion(.success(nftItemResult))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()

    }
    
    private func makeRequest(for networkRequestModel: NetworkRequest) throws -> URLRequest {
        guard let endpoint = networkRequestModel.endpoint else {
            throw FavoriteNftsService.notEnoughDataForRequest
        }
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = networkRequestModel.httpMethod.rawValue
        return urlRequest
    }
 }





