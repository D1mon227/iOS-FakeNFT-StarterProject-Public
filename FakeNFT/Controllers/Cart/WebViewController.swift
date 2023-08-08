//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Денис on 08.08.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView(frame: view.bounds)
        if let url = url {
            webView.load(URLRequest(url: url))
        }
        view.addSubview(webView)
    }
}
