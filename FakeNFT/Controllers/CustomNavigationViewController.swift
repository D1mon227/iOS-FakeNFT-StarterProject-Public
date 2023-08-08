//
//  CustomNavigationViewController.swift
//  FakeNFT
//
//  Created by Dmitry Medvedev on 29.07.2023.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if viewController == viewControllers.first {
            viewController.navigationItem.leftBarButtonItem = nil
        } else {
            let backButton = UIButton(type: .system)
            backButton.setImage(Resourses.Images.Button.backButton, for: .normal)
            backButton.tintColor = .blackDay
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            let backButtonBarItem = UIBarButtonItem(customView: backButton)
            viewController.navigationItem.leftBarButtonItem = backButtonBarItem
        }
        
        viewController.hidesBottomBarWhenPushed = true
    }
    
    @objc private func backButtonTapped() {
        popViewController(animated: true)
    }
}
