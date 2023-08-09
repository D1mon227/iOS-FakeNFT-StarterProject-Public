//
//  CartModel.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import Foundation

protocol CartPresenterProtocol {
    func getNFTsFromAPI(nftID: String, completion: @escaping (CartStruct?) -> Void)
    func cartNFTs(completion: @escaping (OrdersStruct?) -> Void)
    func changeCart(newArray: [String], completion: @escaping () -> Void)
    
}

final class CartPresenter: CartPresenterProtocol {
    
    var urlString = "https://64858e8ba795d24810b71189.mockapi.io"
    
    func getNFTsFromAPI(nftID: String, completion: @escaping (CartStruct?) -> Void) {
        guard let url = URL(string: urlString + "/api/v1/nft/" + nftID) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(CartStruct.self, from: data)
                    completion(result)
                } catch {
                    print("Error decoding cart data: \(error)")
                    completion(nil)
                }
            } else {
                print("Error fetching cart data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
        session.resume()
    }
    
    func cartNFTs(completion: @escaping (OrdersStruct?) -> Void) {
        let requestURL = urlString + "/api/v1/orders/1" // Make sure the URL is correct
        guard let url = URL(string: requestURL) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(OrdersStruct.self, from: data)
                    completion(result)
                } catch {
                    print("Error decoding orders data: \(error)")
                    completion(nil)
                }
            }
        })
        session.resume()
    }
    
    
    func changeCart(newArray: [String], completion: @escaping () -> Void) {
        let request = urlString + "api/v1/orders/1"
        guard let url = URL(string: request) else { return }
        let parameters = [
            "nfts": newArray
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(OrdersStruct.self, from: data)
                        completion()
                    } catch {
                        print(response)
                        print("Ошибка загрузки данных корзины \(error)")
                    }
                }
            })
            session.resume()
        } catch {
            print("Ошибка сериализации параметров в JSON: \(error)")
        }
    }
    
}

