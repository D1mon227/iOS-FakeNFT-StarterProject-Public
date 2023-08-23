//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import UIKit
import Kingfisher

protocol PaymentViewProtocol: AnyObject {
    func updateCurrencies(_ currencies: [PaymentStruct])
    func showSuccessPayment()
    func showFailedPayment()
    func showErrorFetchingCurrencies(message: String)
}

final class PaymentViewController: UIViewController, PaymentViewNavigationDelegate {
    
    func showWebViewController(withURL url: URL) {
        let webViewController = WebViewController(presenter: WebViewPresenter(urlRequest: URLRequest(url: url)))
        present(webViewController, animated: true, completion: nil)
    }
    
    func showErrorFetchingCurrencies(message: String) {
        showFetchErrorAlertAndRetry(message: message)
    }
    
    private let analyticsService = AnalyticsService.shared
    
    private var presenter: PaymentPresenterProtocol?
    
    private var model: PaymentModel?
    
    private var paymentArray: [PaymentStruct] = []
    
    private var isCellSelected: Int = -1
    
    private let paymentView = PaymentView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        analyticsService.report(event: .open, screen: .paymentMethodVC, item: nil)
        setupProperties()
        setupView()
        presenter = PaymentPresenter(view: self, model: PaymentModel())
        presenter?.fetchCurrencies()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

// MARK: - Private methods
extension PaymentViewController: PaymentViewDelegate {
    
    // MARK: - Functions & Methods
    // Appearance customisation
    private func setupView() {
        view.addSubview(paymentView)
        paymentView.delegate = self // Make sure self is of type PaymentViewDelegate
        paymentView.frame = view.bounds
    }
    
    
    private func setupProperties() {
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc
    internal func payButtonTapped(selectedIndex: Int) {
        analyticsService.report(event: .click, screen: .paymentMethodVC, item: .pay)
        print("Selected cell index: \(selectedIndex)")
        if selectedIndex != -1 {
            let selectedPayment = paymentArray[selectedIndex - 1]
            print("Selected payment ID: \(selectedPayment.id)")
            presenter?.performPayment(selectedPaymentIndex: selectedIndex - 1)
        }
    }
    
    
    internal func labelTapped() -> WebViewController? {
        analyticsService.report(event: .click, screen: .paymentMethodVC, item: .userAgreement)
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else {
            print("Invalid URL")
            return nil
        }
        
        let webViewPresenter = WebViewPresenter(urlRequest: URLRequest(url: url))
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        
        present(webViewController, animated: true, completion: nil)
        return webViewController
    }
    
}

extension PaymentViewController: PaymentViewProtocol {
    
    func updateCurrencies(_ currencies: [PaymentStruct]) {
        paymentArray = currencies
        paymentView.paymentArray = currencies
        paymentView.updateCurrencies(currencies)
    }
    
    func showSuccessPayment() {
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let successVC = SucceedPaymentViewController()
        successVC.modalPresentationStyle = .fullScreen
        successVC.modalTransitionStyle = .crossDissolve
        customNC.pushViewController(successVC, animated: true)
        customNC.setNavigationBarHidden(true, animated: true)
    }
    
    func showFailedPayment() {
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let failedVC = FailedPaymentViewController()
        failedVC.modalPresentationStyle = .fullScreen
        failedVC.modalTransitionStyle = .crossDissolve
        customNC.pushViewController(failedVC, animated: true)
        customNC.setNavigationBarHidden(true, animated: true)
    }
    
}


extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isCellSelected = indexPath.row + 1// Update the selected index
        print("Selected cell index: \(isCellSelected)")
        analyticsService.report(event: .click, screen: .paymentMethodVC, item: .currency)
    }
}


extension PaymentViewController {
    private func showFetchErrorAlertAndRetry(message: String) {
        let alertController = UIAlertController(title: "No internet",
                                                message: "Please check your internet connection and try again",
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: NSLocalizedString("Retry", comment: ""),
                                        style: .default) { [weak self] _ in
            self?.presenter?.fetchCurrencies() // Retry fetching data
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
