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
        image.image = UIImage(named: "successImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let successText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(nil, action: #selector(backTapped), for: .touchUpInside)
        button.setTitle("Вернуться в каталог", for: .normal)
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
    
    private func setupView() {
        view.backgroundColor = .white
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
    func backTapped() {
        let catalog = CatalogViewController()
        catalog.modalPresentationStyle = .fullScreen
        catalog.modalTransitionStyle = .crossDissolve
        present(catalog, animated: true)
    }
    
}
