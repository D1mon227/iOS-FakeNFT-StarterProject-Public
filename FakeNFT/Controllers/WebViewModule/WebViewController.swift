//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 07.08.2023.
//

import UIKit
import WebKit

protocol WebViewControllerProtocol: AnyObject {
    func load(request: URLRequest)
}

final class WebViewController: UIViewController, WebViewControllerProtocol {
    //MARK: - Properties
    private let webView = WKWebView()

    //MARK: - presenter
    private let presenter: WebViewPresenterProtocol
    
    init(presenter: WebViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        webView.navigationDelegate = self
        presenter.viewDidLoad()
    }

    //MARK: - Helpers
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    private func setupConstraints() {
		view.backgroundColor = UIColor.backgroundDay
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        decisionHandler(.allow)
    }

}

