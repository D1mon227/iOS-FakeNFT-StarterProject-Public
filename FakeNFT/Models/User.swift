//
//  User.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 03.08.2023.
//

import Foundation

struct User: Decodable {
	let name: String
	let avatar: URL?
	let description: String
	let website: URL
	let nfts: [String]
	let rating: String
	let id: String
}

