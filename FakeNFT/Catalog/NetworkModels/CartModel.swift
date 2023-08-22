//
//  CartModel.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 13.08.2023.
//

import Foundation

struct CartModel: Codable {
    let nfts: [String]
    let id: String
}
