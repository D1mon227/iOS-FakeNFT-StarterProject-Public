//
//  WebViewPresenter.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 07.08.2023.
//

import UIKit

protocol WebViewPresenterProtocol {
    func viewDidLoad()
}

final class WebViewPresenter {
    
    weak var view: WebViewControllerProtocol?
    
    private let urlRequest: URLRequest
    
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
}

extension WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {
        view?.load(request: urlRequest)
    }

}
