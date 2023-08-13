//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 10.08.2023.
//

import Foundation

struct ProfileModel: Codable {
    let name: String
    let avatar: URL?
    let description: String
    let website: URL
    let nfts: [String]
    let likes: [String]
    let id: String
}

