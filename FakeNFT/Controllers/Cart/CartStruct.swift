//
//  CartStruct.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import Foundation

 struct CartStruct: Codable {
     var nftImages: [String]
     var nftName: String
     var nftRating: Int
     var nftPrice: Double

     private enum CodingKeys: String, CodingKey {
         case nftName = "name"
         case nftImages = "images"
         case nftRating = "rating"
         case nftPrice = "price"
     }
 }
struct OrdersStruct: Codable {
    let nfts: [String]
    let id: String
}
