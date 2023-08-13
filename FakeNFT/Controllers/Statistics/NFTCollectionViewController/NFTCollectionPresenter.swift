import UIKit

protocol INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView)
}

final class NFTCollectionPresenter {
	var ui: INFTCollectionView?
	let networkClient = DefaultNetworkClient()
	var order: [Order] = []
	
	func fetchNFTsForUser(nftIds: [String]) {
		DispatchQueue.main.async {
			self.ui?.activatedIndicator()
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
			self?.ui?.deactivatedIndicator()
			self?.ui?.updateUI(with: userNFTs)
		}
	}
	
	func fetchLikesFromServer() {
		let request = GetLikesForUserRequest()
		networkClient.send(request: request, type: Profile.self) {  result in
			switch result {
			case let .success(likes):
				self.ui?.showFavorites(with: likes)
			case let .failure(error):
				print("Error fetching data:", error)
			}
		}
	}
	
	func fetchOrdersFromServer() {
		let request = GetOrdersForUserRequest()
		networkClient.send(request: request, type: Order.self) {  result in
			switch result {
			case let .success(order):
				self.ui?.showCart(with: order)
				self.order.append(order)
			case let .failure(error):
				print("Error fetching data:", error)
			}
		}
	}
	
	func putOrderFromServer(order: Order) {
		let putRequest = PutOrderRequest(dto: order)
		networkClient.send(request: putRequest) { result in
			switch result {
			case .success(_): break
				
			case .failure(let error):
				print("Ошибка при выполнении PUT-запроса: \(error)")
			}
		}
	}
	
	func tapOnTheCell(for nftID: String, id: String) {
		if let orderIndex = order.firstIndex(where: { $0.id == id }) {
			var updatedOrder = order[orderIndex]
			
			if let nftIndex = updatedOrder.nfts.firstIndex(of: nftID) {
				updatedOrder.nfts.remove(at: nftIndex)
				order[orderIndex] = updatedOrder
				print("Removed nftID: \(nftID)")
			} else {
				updatedOrder.nfts.append(nftID)
				order[orderIndex] = updatedOrder
				print("Added nftID: \(nftID)")
			}
			
			putOrderFromServer(order: updatedOrder)
			ui?.showCart(with: updatedOrder)
		}
	}
}

extension NFTCollectionPresenter: INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView) {
		self.ui = ui
		self.ui?.setDelegateDataSource()
	}
}
