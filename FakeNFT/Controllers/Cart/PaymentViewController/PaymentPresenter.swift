//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Денис on 10.08.2023.
//

import Foundation

protocol PaymentPresenterProtocol {
    func fetchCurrencies()
    func performPayment(selectedPaymentIndex: Int)
}

protocol PaymentViewNavigationDelegate: AnyObject {
    func showWebViewController(withURL url: URL)
}

class PaymentPresenter: PaymentPresenterProtocol {
    weak var view: PaymentViewProtocol?
    var model: PaymentModelProtocol?
    
    
    init(view: PaymentViewProtocol, model: PaymentModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func fetchCurrencies() {
        model?.getCurrenciesFromAPI { currencies in
            DispatchQueue.main.async {
                self.view?.updateCurrencies(currencies)
            }
        }
    }
    
    func performPayment(selectedPaymentIndex: Int) {
        guard selectedPaymentIndex >= 0 else {
            return
        }
        
        model?.getCurrenciesFromAPI { currencies in
            guard selectedPaymentIndex < currencies.count else {
                return
            }
            
            let selectedPayment = currencies[selectedPaymentIndex]
            self.model?.getPaymentResult(currencyID: selectedPayment.id) { payment in
                DispatchQueue.main.async {
                    if payment.success {
                        self.view?.showSuccessPayment()
                    } else {
                        self.view?.showFailedPayment()
                    }
                }
            }
        }
    }
}
