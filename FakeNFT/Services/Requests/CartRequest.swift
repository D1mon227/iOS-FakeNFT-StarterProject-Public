//
//  CartRequest.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 13.08.2023.
//

import Foundation

enum CartRequest: NetworkRequest {
    
    case getOrder(id: String)
    case putOrder(id: String)
    
    var endpoint: URL? {
        switch self {
        case .putOrder(let id):
            return URL(string: "\(baseURL)/api/v1/orders/\(id)")
        case .getOrder(let id):
            return URL(string: "\(baseURL)/api/v1/orders/\(id)")
        }
    }
    
    var baseURL: String {
        return "https://64c5171bc853c26efada7b56.mockapi.io"
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .putOrder:
            return .put
        case .getOrder:
            return .get
        }
    }
}
