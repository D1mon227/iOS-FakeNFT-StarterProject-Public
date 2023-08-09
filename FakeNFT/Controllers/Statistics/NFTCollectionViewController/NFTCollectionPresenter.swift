import UIKit

protocol INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView)
}

final class NFTCollectionPresenter {
	var ui: INFTCollectionView?
	let networkClient = DefaultNetworkClient()
	
	func fetchNFTsForUser(nftIds: [String]) {
		DispatchQueue.main.async {
			self.ui?.activityIndicator.startAnimating()
		}
		
		let dispatchGroup = DispatchGroup()
		var userNFTs: [NFT] = []
		
		for nftId in nftIds {
			dispatchGroup.enter()
			let request = GetNFTsForUserRequest(nftId: nftId)
			networkClient.send(request: request, type: NFT.self) { result in
				
				switch result {
				case let .success(nft):
					userNFTs.append(nft)
				case let .failure(error):
					print("Error fetching NFT for ID \(nftId): \(error)")
				}
				dispatchGroup.leave()
			}
		}
		
		dispatchGroup.notify(queue: .main) { [weak self] in
			self?.ui?.activityIndicator.stopAnimating()
			self?.ui?.updateUI(with: userNFTs)
		}
	}
	
	func fetchLikesFromServer() {
		let request = GetLikesForUserRequest()
		networkClient.send(request: request, type: Profile.self) {  result in
			switch result {
			case let .success(likes):
				self.ui?.fetchLikes(with: likes)
			case let .failure(error):
				print("Error fetching data:", error)
			}
		}
	}
	
//	func sendToPut() {
//		guard let url = URL(string: "123") else { return }
//		let userData = putUser(name: "1", avatar: url, description: "32", website: url, nfts: ["23"], likes: ["32"], id: "1")
//		let putRequest = PutUsersRequest(dto: userData)
//
//		networkClient.send(request: putRequest) { result in
//			switch result {
//			case .success(let data):
//				// Обработка успешного ответа от сервера, если нужно
//				print("Успешный ответ от сервера. Данные: \(data)")
//			case .failure(let error):
//				// Обработка ошибки, если запрос не удался или сервер вернул ошибку
//				print("Ошибка при выполнении PUT-запроса: \(error)")
//			}
//		}
//	}
}

extension NFTCollectionPresenter: INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView) {
		self.ui = ui
		self.ui?.setDelegateDataSource(delegate: ui)
	}
}
