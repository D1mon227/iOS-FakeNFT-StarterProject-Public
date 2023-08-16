//
//  NetworkErrorView.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 15.08.2023.
//

import UIKit

struct NFTNetworkErrorViewModel {
    let networkErrorImageName: String
    let notificationNetworkTitle: String
}

extension NetworkErrorView {
    enum Layout {
        static let networkErrorImageHeight: CGFloat = 80
        static let networkErrorImageWidth: CGFloat = 80
    }
}

extension NetworkErrorView {
    enum NFTNetworkError: Error {
        case codeError, invalidUrl, networkTaskError
    }
}

final class NetworkErrorView: UIView {
    
    // MARK: - Properties
    
    private let networkErrorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    private var networkErrorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private var notificationNetworkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let reloadNetworkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var model: NFTNetworkErrorViewModel
    
    init(model: NFTNetworkErrorViewModel) {
        self.model = model
        super.init(frame: .zero)
        addSubview(networkErrorView)
        setupView()
        updateData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    
    private func updateData() {
        networkErrorImage.image = UIImage(named: model.networkErrorImageName)
        notificationNetworkLabel.text = model.notificationNetworkTitle
    }
    
    private func setupView() {
        networkErrorView.addSubview(networkErrorImage)
        networkErrorView.addSubview(notificationNetworkLabel)
        networkErrorView.addSubview(reloadNetworkButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //networkErrorView
            networkErrorView.topAnchor.constraint(equalTo: topAnchor),
            networkErrorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            networkErrorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            networkErrorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            //networkErrorImage
            networkErrorImage.centerXAnchor.constraint(equalTo: networkErrorView.centerXAnchor),
            networkErrorImage.centerYAnchor.constraint(equalTo: networkErrorView.centerYAnchor),
            networkErrorImage.heightAnchor.constraint(equalToConstant: Layout.networkErrorImageHeight),
            networkErrorImage.widthAnchor.constraint(equalToConstant: Layout.networkErrorImageWidth),
            //notificationNetworkLabel
            notificationNetworkLabel.topAnchor.constraint(equalTo: networkErrorImage.bottomAnchor),
            notificationNetworkLabel.centerXAnchor.constraint(equalTo: networkErrorImage.centerXAnchor),
            notificationNetworkLabel.centerYAnchor.constraint(equalTo: networkErrorImage.centerYAnchor),
            //reloadNetworkButton
            reloadNetworkButton.topAnchor.constraint(equalTo: notificationNetworkLabel.bottomAnchor),
            reloadNetworkButton.centerXAnchor.constraint(equalTo: networkErrorImage.centerXAnchor),
            reloadNetworkButton.centerYAnchor.constraint(equalTo: networkErrorImage.centerYAnchor),
        ])
    }
}
