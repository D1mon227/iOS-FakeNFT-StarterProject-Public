//
//  UIViewController+extension.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 17.08.2023.
//

import UIKit

extension UIViewController {
    static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = ","
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    func addNetworkErrorView(model: NetworkErrorViewModel) {
        view.subviews.forEach { view in
            if view is NetworkErrorView {
                return
            }
        }
        let networkErrorView = NetworkErrorView(model: model)
        view.addSubview(networkErrorView)
        networkErrorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            networkErrorView.topAnchor.constraint(equalTo: view.topAnchor),
            networkErrorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            networkErrorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkErrorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func removeNetworkErrorView() {
        view.subviews.forEach { view in
            if view is NetworkErrorView {
                view.removeFromSuperview()
            }
        }
    }
    
    func convert(price: Double) -> String {
        UIViewController.numberFormatter.string(from: NSNumber(value: price)) ?? ""
    }
}
