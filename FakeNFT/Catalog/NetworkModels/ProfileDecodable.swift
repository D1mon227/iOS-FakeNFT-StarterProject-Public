//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 10.08.2023.
//

import Foundation

struct ProfileDecodable: Codable {
    let name: String
    let avatar: URL?
    let description: String
    let website: URL
    let nfts: [String]
    let likes: [String]
    let id: String
}

struct ProfileEncodable: Encodable {
    let likes: [String]
    let website: String
    let name: String
    let description: String
}
