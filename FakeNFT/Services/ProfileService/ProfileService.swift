//
//  FavoriteNftsService.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 10.08.2023.
//

import Foundation

extension ProfileService {
    enum ProfileServiceError: Error {
        case parseError, networkError, notEnoughDataForRequest
    }
}

protocol ProfileServiceProtocol {
    func getProfile(id: String,
                    completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func putProfile(user: ProfileModel, completion: @escaping (Result<ProfileModel, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    private let urlSession = URLSession.shared
    
    func getProfile(id: String,
                    completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        assert(Thread.isMainThread)

        let modelRequest = ProfileRequest.getProfileById(id: id)
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileModel, Error>) in
   
            DispatchQueue.main.async {
                
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()

    }
    
    func putProfile(user: ProfileModel, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let modelRequest = ProfileRequest.putProfile(user: user)
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileModel, Error>) in

            DispatchQueue.main.async {
                
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func makeRequest(for networkRequestModel: NetworkRequest) throws -> URLRequest {
        guard let endpoint = networkRequestModel.endpoint else {
            throw ProfileServiceError.notEnoughDataForRequest
        }
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = networkRequestModel.httpMethod.rawValue
        return urlRequest
    }
 }






