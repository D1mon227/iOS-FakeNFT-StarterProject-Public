//
//  CartRequest.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 13.08.2023.
//

import Foundation

enum CartRequest: NetworkRequest {
    
    case getOrder(id: String)
    case putOrder(cart: CartModel)
    
    var endpoint: URL? {
        switch self {
        case .putOrder(let cart):
            return URL(string: "\(baseURL)/api/v1/orders/\(cart.id)")
        case .getOrder(let id):
            return URL(string: "\(baseURL)/api/v1/orders/\(id)")
        }
    }
    
    var baseURL: String {
        return "https://64858e8ba795d24810b71189.mockapi.io"
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .putOrder:
            return .put
        case .getOrder:
            return .get
        }
    }
    
    var params: [URLQueryItem] {
        switch self {
        case .getOrder:
            return []
        case .putOrder(let cart):
            return [
                URLQueryItem(name: "nfts", value: cart.nfts.joined(separator: ","))
            ]
        }
    }

}


