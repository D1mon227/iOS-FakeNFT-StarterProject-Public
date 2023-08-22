//
//  LoadableProtocol.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 14.08.2023.
//

import Foundation

protocol LoadableProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
