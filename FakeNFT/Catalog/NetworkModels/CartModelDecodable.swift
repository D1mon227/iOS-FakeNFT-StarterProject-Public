//
//  CartModel.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 13.08.2023.
//

import Foundation

struct CartModelDecodable: Decodable {
    let nfts: [String]
    let id: String
}

struct CartModelEncodable: Encodable {
    let nfts: [String]
}
