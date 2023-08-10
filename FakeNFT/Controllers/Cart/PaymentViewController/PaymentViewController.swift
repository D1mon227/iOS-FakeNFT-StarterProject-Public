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
}

class PaymentViewController: UIViewController, PaymentViewProtocol, PaymentViewDelegate {
    
    var presenter: PaymentPresenterProtocol?
    
    var model: PaymentModel?
    
    var paymentArray: [PaymentStruct] = []
    
    var isCellSelected: Int = -1
    
    private let paymentView = PaymentView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension PaymentViewController {
    
    // MARK: - Functions & Methods
    //    / Appearance customisation
    private func setupView() {
        view.addSubview(paymentView)
        paymentView.delegate = self // Make sure self is of type PaymentViewDelegate
        paymentView.frame = view.bounds
    }
    
    
    private func setupProperties() {
        tabBarController?.tabBar.isHidden = true
    }
    func updateCurrencies(_ currencies: [PaymentStruct]) {
        paymentArray = currencies
        paymentView.paymentArray = currencies // Make sure you're setting the paymentArray in the PaymentView
        paymentView.updateCurrencies(currencies)
    }
    
    
    func showSuccessPayment() {
        let successVC = SucceedPaymentViewController()
        successVC.modalPresentationStyle = .fullScreen
        successVC.modalTransitionStyle = .crossDissolve
        present(successVC, animated: false, completion: nil)
    }
    
    func showFailedPayment() {
        let failedVC = FailedPaymentViewController()
        failedVC.modalPresentationStyle = .fullScreen
        failedVC.modalTransitionStyle = .crossDissolve
        present(failedVC, animated: false, completion: nil)
    }
    
    @objc
    func payButtonTapped(selectedIndex: Int) {
        print("Selected cell index: \(selectedIndex)")
        if selectedIndex != -1 {
            let selectedPayment = paymentArray[selectedIndex - 1]
            print("Selected payment ID: \(selectedPayment.id)")
            presenter?.performPayment(selectedPaymentIndex: selectedIndex - 1)
        }
    }
    
    
    @objc func labelTapped() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else {
            print("Invalid URL")
            return
        }
        
        let webViewController = WebViewController()
        webViewController.url = url
        
        present(webViewController, animated: true, completion: nil)
    }
    
}

extension PaymentViewController: PaymentViewNavigationDelegate {
    func showWebViewController(withURL url: URL) {
        let webViewController = WebViewController()
        webViewController.url = url
        present(webViewController, animated: true, completion: nil)
    }
}


extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isCellSelected = indexPath.row + 1// Update the selected index
        print("Selected cell index: \(isCellSelected)")
    }
}
