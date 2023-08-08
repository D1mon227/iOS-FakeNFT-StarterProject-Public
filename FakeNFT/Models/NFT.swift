//
//  NFT.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 06.08.2023.
//

import Foundation

struct NFT: Decodable {
	let createdAt: String
	let name: String
	let images: [URL]?
	let rating: Int
	let description: String
	let price: Float
	let author: String
	let id: String
}
