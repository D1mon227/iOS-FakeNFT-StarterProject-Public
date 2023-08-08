//
//  CustomNavigationViewController.swift
//  FakeNFT
//
//  Created by Dmitry Medvedev on 29.07.2023.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = false
        } else {
            let backButton = UIButton(type: .system)
            backButton.setImage(Resourses.Images.Button.backButton, for: .normal)
            backButton.tintColor = .blackDay
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            let backButtonBarItem = UIBarButtonItem(customView: backButton)
            viewController.navigationItem.leftBarButtonItem = backButtonBarItem
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }

    @objc private func backButtonTapped() {
        popViewController(animated: true)
    }
}
