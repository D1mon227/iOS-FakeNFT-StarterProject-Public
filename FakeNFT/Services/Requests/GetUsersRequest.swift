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
