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

final class PaymentPresenter: PaymentPresenterProtocol {
    private weak var view: PaymentViewProtocol?
    private let model: PaymentModelProtocol?
    
    
    init(view: PaymentViewProtocol, model: PaymentModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func fetchCurrencies() {
        model?.getCurrenciesFromAPI { [weak self] currencies in
            DispatchQueue.main.async {
                self?.view?.updateCurrencies(currencies)
            }
        }
    }
    
    func performPayment(selectedPaymentIndex: Int) {
        guard selectedPaymentIndex >= 0 else {
            return
        }
        
        model?.getCurrenciesFromAPI { [weak self] currencies in
            guard let self = self else {
                return
            }
            
            guard selectedPaymentIndex < currencies.count else {
                return
            }
            
            let selectedPayment = currencies[selectedPaymentIndex]
            self.model?.getPaymentResult(currencyID: selectedPayment.id) { [weak self] payment in
                guard let self = self else {
                    return
                }
                
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
