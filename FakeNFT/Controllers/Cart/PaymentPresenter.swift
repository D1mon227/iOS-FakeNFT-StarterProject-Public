//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Денис on 08.08.2023.
//

import Foundation

protocol PaymentPresenterProtocol {
    func getCurrenciesFromAPI(completion: @escaping ([PaymentStruct]) -> Void)
}

final class PaymentPresenter: PaymentPresenterProtocol {

    var urlString = "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/currencies"
    
    func getCurrenciesFromAPI(completion: @escaping ([PaymentStruct]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([PaymentStruct].self, from: data)
                    completion(result)
                } catch {
                    print(response)
                }
            }
        }).resume()
    }
    
}

