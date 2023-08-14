import UIKit

protocol INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView)
}

final class NFTCollectionPresenter {
	private var ui: INFTCollectionView?
	private var order: [Order] = []
	private var likes: [Likes] = []
	private let networkClient = DefaultNetworkClient()
	
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
				case .success(let nft):
					userNFTs.append(nft)
				case .failure(let error):
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
			case .success(let profile):
				let likes = Likes(likes: profile.likes)
				self.ui?.showFavorites(with: likes)
				self.likes.append(likes)
			case .failure(let error):
				print("Error fetching data:", error)
			}
		}
	}
	
	func fetchOrdersFromServer() {
		let request = GetOrdersForUserRequest()
		networkClient.send(request: request, type: Order.self) {  result in
			switch result {
			case .success(let order):
				self.ui?.showCart(with: order)
				self.order.append(order)
			case .failure(let error):
				print("Error fetching data:", error)
			}
		}
	}
	
	func putOrderToServer(order: Order) {
		let putRequest = PutOrderRequest(dto: order)
		networkClient.send(request: putRequest) { result in
			switch result {
			case .success(_): break
				
			case .failure(let error):
				print("Ошибка при выполнении PUT-запроса: \(error)")
			}
		}
	}
	
	func putLikesToServer(likes: Likes) {
		let putRequest = PutLikesRequest(dto: likes)
		networkClient.send(request: putRequest) { result in
			switch result {
			case .success(_): break
				
			case .failure(let error):
				print("Ошибка при выполнении PUT-запроса: \(error)")
			}
		}
	}
	
	func tapOnTheCell(for nftID: String, profile: String) {
		if let orderIndex = order.firstIndex(where: { $0.id == profile }) {
			var updatedOrder = order[orderIndex]
			
			if let nftIndex = updatedOrder.nfts.firstIndex(of: nftID) {
				updatedOrder.nfts.remove(at: nftIndex)
				order[orderIndex] = updatedOrder
				print(nftID)
			} else {
				updatedOrder.nfts.append(nftID)
				order[orderIndex] = updatedOrder
				print(nftID)
			}
			print(updatedOrder)
			putOrderToServer(order: updatedOrder)
			ui?.showCart(with: updatedOrder)
		}
	}
	
	func tapOnTheCell(for nftID: String) {
		if let index = likes.firstIndex(where: { $0.likes.contains(nftID) }) {
			likes[index].likes.removeAll { $0 == nftID }
		} else {
			likes.append(Likes(likes: [nftID]))
		}

		let allLikes: Likes = Likes(likes: likes.flatMap { $0.likes })
		print(allLikes)
		putLikesToServer(likes: allLikes)
		ui?.showFavorites(with: allLikes)
	}
}

extension NFTCollectionPresenter: INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView) {
		self.ui = ui
		self.ui?.setDelegateDataSource()
	}
}
