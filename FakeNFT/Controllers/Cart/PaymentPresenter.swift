//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Денис on 08.08.2023.
//

import Foundation

protocol PaymentPresenterProtocol {
    func getCurrenciesFromAPI(completion: @escaping ([PaymentStruct]) -> Void)
    func getPaymentResult(currencyID: String, completion: @escaping (Payment) -> Void)

}

final class PaymentPresenter: PaymentPresenterProtocol {

    var urlString = "https://64858e8ba795d24810b71189.mockapi.io/api/v1/currencies"
    
//    var urlString = "https://64858e8ba795d24810b71189.mockapi.io/api/v1/nft"

    
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
    
    func getPaymentResult(currencyID: String, completion: @escaping (Payment) -> Void) {
        guard let url = URL(string: "https://64858e8ba795d24810b71189.mockapi.io/api/v1/orders/1/payment/" + currencyID) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(Payment.self, from: data)
                    completion(result)
                } catch {
                    print(response)
                    print("Ошибка загрузки оплаты \(error)")
                }
            }
        }).resume()
    }
    
}

