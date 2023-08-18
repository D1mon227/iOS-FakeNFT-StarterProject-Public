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
	let price: Double?
	let author: String
	let id: String
	
	var formattedPrice: String {
		return String(format: "%.2f ETH", price ?? 0.0).replacingOccurrences(of: ".", with: ",")
	}
}
