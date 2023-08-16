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

final class PaymentViewController: UIViewController {
    
    private var presenter: PaymentPresenterProtocol?
    
    private var model: PaymentModel?
    
    private var paymentArray: [PaymentStruct] = []
    
    private var isCellSelected: Int = -1
    
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
        print("Selected cell index: \(selectedIndex)")
        if selectedIndex != -1 {
            let selectedPayment = paymentArray[selectedIndex - 1]
            print("Selected payment ID: \(selectedPayment.id)")
            presenter?.performPayment(selectedPaymentIndex: selectedIndex - 1)
        }
    }
    
    
    @objc
    internal func labelTapped() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else {
            print("Invalid URL")
            return
        }
        
//        let webViewController = WebViewController()
//        webViewController.url = url
//
//        present(webViewController, animated: true, completion: nil)
    }
    
}

extension PaymentViewController: PaymentViewProtocol {
    
    func updateCurrencies(_ currencies: [PaymentStruct]) {
        paymentArray = currencies
        paymentView.paymentArray = currencies
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
}

//extension PaymentViewController: PaymentViewNavigationDelegate {
//    func showWebViewController(withURL url: URL) {
//        let webViewController = WebViewController()
//        webViewController.url = url
//        present(webViewController, animated: true, completion: nil)
//    }
//}


extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isCellSelected = indexPath.row + 1// Update the selected index
        print("Selected cell index: \(isCellSelected)")
    }
}
