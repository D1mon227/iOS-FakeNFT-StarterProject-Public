//
//  CartModel.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import Foundation

protocol CartPresenterProtocol {
    func getNFTsFromAPI(completion: @escaping ([CartStruct]) -> Void)
}


final class CartPresenter: CartPresenterProtocol {
    
    enum Constants {
        static let urlString = "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/nft/"
    }
    
    func getNFTsFromAPI(completion: @escaping ([CartStruct]) -> Void) {
        guard let url = URL(string: Constants.urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([CartStruct].self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Error loading cart data: \(error)")
                    completion([])
                }
            }
        }).resume()
    }
}

