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
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error updating cart data: \(error)")
                    completion() // Call the completion block even if there's an error
                    return
                }
                
                if let data = data {
                    do {
                        // Decode the response if needed (make sure it matches the expected structure)
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(OrdersStruct.self, from: data)
                        // Check the response and take appropriate actions
                        completion() // Call the completion block on success
                    } catch {
                        print("Error decoding response: \(error)")
                    }
                }
            }
            
            session.resume()
        } catch {
            print("Error serializing parameters to JSON: \(error)")
        }
    }

}

