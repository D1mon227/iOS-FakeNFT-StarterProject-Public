//
//  Profile.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 09.08.2023.
//

import Foundation

struct Profile: Codable {
	let name: String
	let avatar: URL?
	let description: String
	let website: URL
	let nfts: [String]
	let likes: [String]
	let id: String
}

