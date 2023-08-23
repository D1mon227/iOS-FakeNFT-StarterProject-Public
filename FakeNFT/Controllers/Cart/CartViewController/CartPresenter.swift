//
//  CartModel.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import Foundation

protocol CartPresenterProtocol {
    typealias NFTCompletionHandler = (Result<CartStruct, Error>) -> Void
    typealias OrdersCompletionHandler = (Result<OrdersStruct, Error>) -> Void
    
    func getNFTsFromAPI(nftID: String, completion: @escaping NFTCompletionHandler)
    func cartNFTs(completion: @escaping OrdersCompletionHandler)
    func changeCart(newArray: [String], completion: @escaping () -> Void)
}

final class CartPresenter: CartPresenterProtocol {
    
    private let urlString = "https://64c5171bc853c26efada7b56.mockapi.io"
    
    private let queue = DispatchQueue(label: "", qos: .background, attributes: .concurrent)
    
    func getNFTsFromAPI(nftID: String, completion: @escaping NFTCompletionHandler) {
        guard let url = URL(string: urlString + "/api/v1/nft/" + nftID) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }
        
        queue.async {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let result = try decoder.decode(CartStruct.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                print("Error fetching cart data: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func cartNFTs(completion: @escaping OrdersCompletionHandler) {
        let requestURL = urlString + "/api/v1/orders/1"
        guard let url = URL(string: requestURL) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }
        
        queue.async {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let result = try decoder.decode(OrdersStruct.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                print("Error fetching orders data: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func changeCart(newArray: [String], completion: @escaping () -> Void) {
        let requestURL = urlString + "/api/v1/orders/1"
        
        guard let url = URL(string: requestURL) else {
            print("Invalid URL: \(requestURL)")
            return
        }
        
        let parameters = [
            "nfts": newArray
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")
            
            queue.async {
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error updating cart data: \(error)")
                    }
                    completion()
                }
                task.resume()
            }
        } catch {
            print("Error serializing parameters to JSON: \(error)")
        }
    }
}
