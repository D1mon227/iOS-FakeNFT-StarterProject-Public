//
//  CartService.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 13.08.2023.
//

import Foundation

extension CartService {
    enum CartServiceError: Error {
        case parseError, networkError, notEnoughDataForRequest
    }
}

protocol CartServiceProtocol {
    func getOrder(id: String,
                    completion: @escaping (Result<CartModelDecodable, Error>) -> Void)
    func putOrder(cart: CartModelDecodable,
                  completion: @escaping (Result<CartModelDecodable, Error>) -> Void)
}

final class CartService: CartServiceProtocol {
    private let urlSession = URLSession.shared
    
    func getOrder(id: String,
                    completion: @escaping (Result<CartModelDecodable, Error>) -> Void) {
        assert(Thread.isMainThread)

        let modelRequest = CartRequest.getOrder(id: id)
        
        do {
            let request = try makeRequest(for: modelRequest)
            urlSession.objectTask(for: request) { (result: Result<CartModelDecodable, Error>) in
                
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
    
    func putOrder(cart: CartModelDecodable,
                  completion: @escaping (Result<CartModelDecodable, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let modelRequest = CartRequest.putOrder(id: cart.id)
        
        do {
            let request = try makeRequest(for: modelRequest,
                                          model: CartModelEncodable(nfts: cart.nfts))
            urlSession.objectTask(for: request) { (result: Result<CartModelDecodable, Error>) in
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let cart):
                        completion(.success(cart))
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
            throw CartServiceError.notEnoughDataForRequest
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
