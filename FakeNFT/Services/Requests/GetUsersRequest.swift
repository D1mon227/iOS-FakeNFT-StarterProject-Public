//
//  GetUsersRequest.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 03.08.2023.
//

import Foundation

struct GetUsersRequest: NetworkRequest {
	var endpoint: URL? {
		URL(string: "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/users")
	}
}

struct GetLikesForUserRequest: NetworkRequest {
	var endpoint: URL? {
		URL(string: "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/profile/1")
	}
}

struct GetOrdersForUserRequest: NetworkRequest {
	var endpoint: URL? {
		URL(string: "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/orders/1")
	}
}

struct GetNFTsForUserRequest: NetworkRequest {
	let nftId: String
	var endpoint: URL? {
		let urlString = "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/nft/\(nftId)"
		return URL(string: urlString)
	}
}

struct PutOrderRequest: NetworkRequest {
	var endpoint: URL? {
		URL(string: "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/orders/1")
	}
	var httpMethod: HttpMethod { .put }
	var dto: Encodable?
}
