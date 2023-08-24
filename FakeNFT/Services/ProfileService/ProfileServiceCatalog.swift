//
//  FavoriteNftsService.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 10.08.2023.
//

import Foundation

extension ProfileServiceCatalog {
    enum ProfileServiceError: Error {
        case parseError, networkError, notEnoughDataForRequest
    }
}

protocol ProfileServiceProtoco {
    func getProfile(id: String,
                    completion: @escaping (Result<ProfileDecodable, Error>) -> Void)
    func putProfile(user: ProfileDecodable,
                    completion: @escaping (Result<ProfileDecodable, Error>) -> Void)
}

final class ProfileServiceCatalog: ProfileServiceProtoco {
    private let urlSession = URLSession.shared
    
    func getProfile(id: String,
                    completion: @escaping (Result<ProfileDecodable, Error>) -> Void) {
        assert(Thread.isMainThread)

        let modelRequest = ProfileRequestCatalog.getProfileById(id: id)
        
        do {
            let request = try makeRequest(for: modelRequest)
            urlSession.objectTask(for: request) { (result: Result<ProfileDecodable, Error>) in
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch {
            print("Failed")
        }

    }
    
    func putProfile(user: ProfileDecodable,
                    completion: @escaping (Result<ProfileDecodable, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let modelRequest = ProfileRequestCatalog.putProfile(user: user)

        do {
            let model = ProfileEncodable(likes: user.likes,
                                      website: user.website.absoluteString,
                                      name: user.name,
                                      description: user.description)
            let request = try makeRequest(for: modelRequest, model: model)
            
            urlSession.objectTask(for: request) { (result: Result<ProfileDecodable, Error>) in
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch {
            print("Failed")
        }
    }
    
    private func makeRequest(for networkRequestModel: NetworkRequest,
                             model: Encodable? = nil) throws -> URLRequest {
        guard let endpoint = networkRequestModel.endpoint else {
            throw ProfileServiceError.notEnoughDataForRequest
        }
        var urlRequest = URLRequest(url: endpoint)
       
        if let model,
           let dtoEncoded = try? JSONEncoder().encode(model) {
            urlRequest.httpBody = dtoEncoded
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpMethod = networkRequestModel.httpMethod.rawValue
        return urlRequest
    }
 }





