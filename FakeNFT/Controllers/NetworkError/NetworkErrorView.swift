//
//  NetworkErrorView.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 15.08.2023.
//

import UIKit

struct NFTNetworkErrorViewModel {
    let networkErrorImage: UIImage?
    let notificationNetworkTitle: String
    let reloadButtonTapped: () -> Void
}

extension NetworkErrorView {
    enum Layout {
        static let networkErrorImageHeight: CGFloat = 150
        static let networkErrorImageWidth: CGFloat = 150
    }
}

extension NetworkErrorView {
    enum NFTNetworkError: Error {
        case codeError, invalidUrl, networkTaskError
    }
}

final class NetworkErrorView: UIView {
    
    // MARK: - Properties
    
    private var networkErrorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private var notificationNetworkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    private let reloadNetworkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(LocalizableConstants.NetworkErrorView.button, for: .normal)
        button.setTitleColor(UIColor.backgroundDay, for: .normal)
        button.backgroundColor = .blackDay
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 9
        button.contentEdgeInsets.left = 10
        button.contentEdgeInsets.right = 10
        button.contentEdgeInsets.top = 10
        button.contentEdgeInsets.bottom = 10
        
        return button
    }()
    
    private var model: NFTNetworkErrorViewModel
    
    init(model: NFTNetworkErrorViewModel) {
        self.model = model
        super.init(frame: .zero)
        backgroundColor = .backgroundDay
        notificationNetworkLabel.textColor = .blackDay
        setupView()
        setupConstraints()
        updateData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func updateData() {
        if let imageName = model.networkErrorImage {
            let renderedImage = imageName.withRenderingMode(.alwaysTemplate)
            networkErrorImage.image = renderedImage
            networkErrorImage.tintColor = .blackDay
        }
        notificationNetworkLabel.text = model.notificationNetworkTitle
    }
    
    private func setupView() {
        addSubview(networkErrorImage)
        addSubview(notificationNetworkLabel)
        addSubview(reloadNetworkButton)
        
        reloadNetworkButton.addTarget(self, action: #selector(reloadNetworkButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //networkErrorImage
            networkErrorImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            networkErrorImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            networkErrorImage.heightAnchor.constraint(equalToConstant: Layout.networkErrorImageHeight),
            networkErrorImage.widthAnchor.constraint(equalToConstant: Layout.networkErrorImageWidth),
            //notificationNetworkLabel
            notificationNetworkLabel.topAnchor.constraint(equalTo: networkErrorImage.bottomAnchor, constant: 20),
            notificationNetworkLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            notificationNetworkLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            notificationNetworkLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            //reloadNetworkButton
            reloadNetworkButton.topAnchor.constraint(equalTo: notificationNetworkLabel.bottomAnchor, constant: 20),
            reloadNetworkButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    @objc func reloadNetworkButtonTapped() {
        model.reloadButtonTapped()
    }
}
