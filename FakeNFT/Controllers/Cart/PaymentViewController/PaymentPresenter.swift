//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Денис on 10.08.2023.
//

import Foundation
import UIKit

protocol PaymentPresenterProtocol {
    func fetchCurrencies()
    func performPayment(selectedPaymentIndex: Int)
}

protocol PaymentViewNavigationDelegate: AnyObject {
    func showWebViewController(withURL url: URL)
}

final class PaymentPresenter: PaymentPresenterProtocol {
    private weak var view: PaymentViewProtocol?
    private let model: PaymentModelProtocol?
    
    init(view: PaymentViewProtocol, model: PaymentModelProtocol) {
        self.view = view
        self.model = model
    }
    
    private let queue = DispatchQueue.global(qos: .background)
    
    func fetchCurrencies() {
        UIBlockingProgressHUD.show()
        queue.async { [weak self] in
            self?.model?.getCurrenciesFromAPI { result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let currencies):
                        self?.view?.updateCurrencies(currencies)
                        UIBlockingProgressHUD.dismiss()
                    case .failure(let error):
                        // Handle the error by showing an alert
                        self?.view?.showErrorFetchingCurrencies(message: error.localizedDescription)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    
    func performPayment(selectedPaymentIndex: Int) {
        guard selectedPaymentIndex >= 0 else {
            return
        }
        UIBlockingProgressHUD.show()
        queue.async { [weak self] in
            self?.model?.getCurrenciesFromAPI { currenciesResult in
                guard let self = self else {
                    return
                }
                
                switch currenciesResult {
                case .success(let currencies):
                    guard selectedPaymentIndex < currencies.count else {
                        return
                    }
                    
                    let selectedPayment = currencies[selectedPaymentIndex]
                    self.model?.getPaymentResult(currencyID: selectedPayment.id) { [weak self] paymentResult in
                        guard let self = self else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            switch paymentResult {
                            case .success(let payment):
                                if payment.success {
                                    UIBlockingProgressHUD.dismiss()
                                    self.view?.showSuccessPayment()
                                } else {
                                    UIBlockingProgressHUD.dismiss()
                                    self.view?.showFailedPayment()
                                }
                            case .failure(let error):
                                // Handle the payment error
                                self.view?.showErrorFetchingCurrencies(message: error.localizedDescription)
                                print("Error fetching payment result: \(error)")
                                UIBlockingProgressHUD.dismiss()
                            }
                        }
                    }
                case .failure(let error):
                    // Handle the currencies error
                    print("Error fetching currencies: \(error)")
                    self.view?.showErrorFetchingCurrencies(message: error.localizedDescription)
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
}



