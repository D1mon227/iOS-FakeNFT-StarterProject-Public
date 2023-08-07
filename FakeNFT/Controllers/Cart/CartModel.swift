//
//  CartModel.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import Foundation

protocol CartModelProtocol {
    
    func getNFT(nftID: String, completion: @escaping (CartStruct) -> Void)
    
}

final class CartModel: CartModelProtocol {
    
//    var urlString = "https://64c5171bc853c26efada7b56.mockapi.io/v1/profile/1"
    var urlString = "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/orders/1"
    
    
    
    func getNFT(nftID: String, completion: @escaping (CartStruct) -> Void) {
        let requestString = urlString + nftID
        guard let url = URL(string: requestString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(CartStruct.self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Ошибка загрузки данных корзины \(error) \(nftID)")
                }
            }
        }).resume()
    }
    
}
