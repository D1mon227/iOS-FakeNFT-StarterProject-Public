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
                    completion: @escaping (Result<CartModel, Error>) -> Void)
    func putOrder(cart: CartModel,
                  completion: @escaping (Result<CartModel, Error>) -> Void)
}

final class CartService: CartServiceProtocol {
    private let urlSession = URLSession.shared
    
    func getOrder(id: String,
                    completion: @escaping (Result<CartModel, Error>) -> Void) {
        assert(Thread.isMainThread)

        let modelRequest = CartRequest.getOrder(id: id)
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        urlSession.objectTask(for: request) { (result: Result<CartModel, Error>) in
   
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
    
    func putOrder(cart: CartModel,
                  completion: @escaping (Result<CartModel, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let modelRequest = CartRequest.putOrder(cart: cart)
        
        //обработать ошибку
        let request = try! makeRequest(for: modelRequest)
        urlSession.objectTask(for: request) { (result: Result<CartModel, Error>) in

            DispatchQueue.main.async {
                
                switch result {
                case .success(let cart):
                    completion(.success(cart))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func makeRequest(for networkRequestModel: NetworkRequest) throws -> URLRequest {
        guard let endpoint = networkRequestModel.endpoint else {
            throw CartServiceError.notEnoughDataForRequest
        }
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = networkRequestModel.httpMethod.rawValue
        return urlRequest
    }
 }







