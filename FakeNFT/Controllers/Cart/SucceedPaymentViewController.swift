//
//  SucceedPaymentViewController.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import UIKit

final class SucceedPaymentViewController: UIViewController {
    
    // MARK: - Properties
    
    let image: UIImageView = {
        let image = UIImageView()
        image.image = Resourses.Images.SuccessFailPayment.succeedPayment
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let successText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = LocalizableConstants.Cart.successfulPayment
        label.textColor = .blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.setTitleColor(.backgroundDay, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(backTapped), for: .touchUpInside)
        button.setTitle(LocalizableConstants.Cart.backToCatalog, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Functions & Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            successText.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            successText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func setupProperties() {
        view.addSubview(image)
        view.addSubview(successText)
        view.addSubview(backButton)
    }
    
    @objc
    private func backTapped() {
        let tabBarController = TabBarController()
        tabBarController.selectedIndex = 1 // Set the index of the CatalogViewController
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true, completion: nil)
    }
    
}
