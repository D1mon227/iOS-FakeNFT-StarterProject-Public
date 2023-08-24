//
//  CartStruct.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import Foundation

struct Cart: Codable {
    var nftImages: [String]
    var nftName: String
    var nftRating: Int
    var nftPrice: Double
    var nftID: String
    
    private enum CodingKeys: String, CodingKey {
        case nftName = "name"
        case nftImages = "images"
        case nftRating = "rating"
        case nftPrice = "price"
        case nftID = "id"
    }
}
