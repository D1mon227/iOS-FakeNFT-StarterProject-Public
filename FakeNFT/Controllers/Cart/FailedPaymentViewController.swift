//
//  FailedPaymentViewController.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import UIKit

final class FailedPaymentViewController: UIViewController {
    
    private let analyticsService = AnalyticsService.shared
    
    // MARK: - Properties
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = Resourses.Images.SuccessFailPayment.failedPayment
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var failText: UILabel = {
        let label = UILabel()
        label.textColor = .blackDay
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = LocalizableConstants.Cart.failedPayment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.setTitleColor(.backgroundDay, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        button.setTitle(LocalizableConstants.Cart.tryAgain, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Functions & Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyticsService.report(event: .open, screen: .successFailureVC, item: nil)
        setupProperties()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    
    private func setupView() {
        view.backgroundColor = .backgroundDay
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            failText.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            failText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            failText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func setupProperties() {
        view.addSubview(image)
        view.addSubview(failText)
        view.addSubview(backButton)
    }
    
    @objc private func backTapped() {
        analyticsService.report(event: .click, screen: .successFailureVC, item: .tryAgain)
        guard let customNC = navigationController as? CustomNavigationController else { return }
        customNC.popToRootViewController(animated: true)
    }
}

