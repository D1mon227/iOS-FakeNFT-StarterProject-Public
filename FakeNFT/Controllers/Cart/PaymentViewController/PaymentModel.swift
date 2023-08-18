//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Денис on 08.08.2023.
//

//import Foundation
//
//protocol PaymentModelProtocol {
//    func getCurrenciesFromAPI(completion: @escaping ([PaymentStruct]) -> Void)
//    func getPaymentResult(currencyID: String, completion: @escaping (Payment) -> Void)
//
//}
//
//final class PaymentModel: PaymentModelProtocol {
//
//    private let urlString = "https://64858e8ba795d24810b71189.mockapi.io/api/v1/currencies"
//
//    func getCurrenciesFromAPI(completion: @escaping ([PaymentStruct]) -> Void) {
//        guard let url = URL(string: urlString) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
//            if let data = data {
//                let decoder = JSONDecoder()
//                do {
//                    let result = try decoder.decode([PaymentStruct].self, from: data)
//                    completion(result)
//                } catch {
//                    print(response)
//                }
//            }
//        }).resume()
//    }
//
//    func getPaymentResult(currencyID: String, completion: @escaping (Payment) -> Void) {
//        guard let url = URL(string: "https://64858e8ba795d24810b71189.mockapi.io/api/v1/orders/1/payment/" + currencyID) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        let session = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
//            if let data = data {
//                let decoder = JSONDecoder()
//                do {
//                    let result = try decoder.decode(Payment.self, from: data)
//                    completion(result)
//                } catch {
//                    print(response)
//                    print("Ошибка загрузки оплаты \(error)")
//                }
//            }
//        }).resume()
//    }
//
//}



import Foundation

protocol PaymentModelProtocol {
    typealias CurrenciesCompletionHandler = (Result<[PaymentStruct], Error>) -> Void
    typealias PaymentResultCompletionHandler = (Result<Payment, Error>) -> Void
    
    func getCurrenciesFromAPI(completion: @escaping CurrenciesCompletionHandler)
    func getPaymentResult(currencyID: String, completion: @escaping PaymentResultCompletionHandler)
}

final class PaymentModel: PaymentModelProtocol {
    private let urlString = "https://64858e8ba795d24810b71189.mockapi.io/api/v1/currencies"
    
    private let queue = DispatchQueue(label: "", qos: .background, attributes: .concurrent)
    
    func getCurrenciesFromAPI(completion: @escaping CurrenciesCompletionHandler) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }
        
        queue.async {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode([PaymentStruct].self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            session.resume()
        }
    }
    
    func getPaymentResult(currencyID: String, completion: @escaping PaymentResultCompletionHandler) {
        guard let url = URL(string: "https://64858e8ba795d24810b71189.mockapi.io/api/v1/orders/1/payment/" + currencyID) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }
        
        queue.async {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(Payment.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(result))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            session.resume()
        }
    }
}
