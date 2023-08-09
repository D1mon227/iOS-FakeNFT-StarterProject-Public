//
//  Order.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 09.08.2023.
//

import Foundation

struct Order: Codable {
	let nfts: [String]
	let id: String
}
