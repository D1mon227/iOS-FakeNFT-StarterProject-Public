import Foundation

protocol INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView)
	func tapOnTheCell(for nftID: String)
	func tapOnTheCell(for nftID: String, profile: String)
	func tapOnTheCell(nft: NFT)
}

final class NFTCollectionPresenter {
	private weak var ui: INFTCollectionView?
	private let networkClient: DefaultNetworkClient
	private let appCoordinator: AppCoordinator
	private var order: [Order] = []
	private var likes: [Likes] = []
	private var userNFTs: [NFT] = []
	private var model: User?
	
	init(appCoordinator: AppCoordinator, networkClient: DefaultNetworkClient, model: User?) {
		self.appCoordinator = appCoordinator
		self.networkClient = networkClient
		self.model = model
	}
	
	func tapOnTheCell(for nftID: String, profile: String) {
		guard let orderIndex = order.firstIndex(where: { $0.id == profile }) else { return }
		var updatedOrder = order[orderIndex]
		
		if let nftIndex = updatedOrder.nfts.firstIndex(of: nftID) {
			updatedOrder.nfts.remove(at: nftIndex)
			order[orderIndex] = updatedOrder
		} else {
			updatedOrder.nfts.append(nftID)
			order[orderIndex] = updatedOrder
		}
		putOrderToServer(order: updatedOrder)
		ui?.showCart(with: updatedOrder)
	}
	
	func tapOnTheCell(for nftID: String) {
		if let index = likes.firstIndex(where: { $0.likes.contains(nftID) }) {
			likes[index].likes.removeAll { $0 == nftID }
		} else {
			likes.append(Likes(likes: [nftID]))
		}
		
		let allLikes: Likes = Likes(likes: likes.flatMap { $0.likes })
		putLikesToServer(likes: allLikes)
		ui?.showFavorites(with: allLikes)
	}
	
	func tapOnTheCell(nft: NFT) {
		appCoordinator.showNFTCardScreen(nft: nft)
	}
	
	private func fetchNFTsForUser() {
		UIBlockingProgressHUD.show()
		
		let dispatchGroup = DispatchGroup()
		
		guard let nftIds = model?.nfts  else { return }
		for nftId in nftIds {
			dispatchGroup.enter()
			let request = GetNFTsForUserRequest(nftId: nftId)
			networkClient.send(request: request, type: NFT.self) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let nft):
					self.userNFTs.append(nft)
				case .failure(let error):
					print("Error fetching NFT for ID \(nftId): \(error)")
				}
				dispatchGroup.leave()
			}
		}
		
		dispatchGroup.notify(queue: .main) { [weak self] in
			guard let self = self else { return }
			UIBlockingProgressHUD.dismiss()
			self.ui?.updateUI(with: self.userNFTs)
		}
	}
	
	private func fetchLikesFromServer() {
		let request = GetLikesForUserRequest()
		networkClient.send(request: request, type: Profile.self) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let profile):
				let likes = Likes(likes: profile.likes ?? [])
				DispatchQueue.main.async {
					self.ui?.showFavorites(with: likes)
				}
				self.likes.append(likes)
			case .failure(let error):
				print("Error fetching data:", error)
			}
		}
	}
	
	private func fetchOrdersFromServer() {
		let request = GetOrdersForUserRequest()
		networkClient.send(request: request, type: Order.self) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let order):
				DispatchQueue.main.async {
					self.ui?.showCart(with: order)
				}
				self.order.append(order)
			case .failure(let error):
				print("Error fetching data:", error)
			}
		}
	}
	
	private func putOrderToServer(order: Order) {
		let putRequest = PutOrderRequest(dto: order)
		networkClient.send(request: putRequest) { result in
			switch result {
			case .success(_): break
				
			case .failure(let error):
				print("Ошибка при выполнении PUT-запроса: \(error)")
			}
		}
	}
	
	private func putLikesToServer(likes: Likes) {
		let putRequest = PutLikesRequest(dto: likes)
		networkClient.send(request: putRequest) { result in
			switch result {
			case .success(_): break
				
			case .failure(let error):
				print("Ошибка при выполнении PUT-запроса: \(error)")
			}
		}
	}
}

extension NFTCollectionPresenter: INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView) {
		self.ui = ui
		self.ui?.setDelegateDataSource()
		fetchNFTsForUser()
		fetchLikesFromServer()
		fetchOrdersFromServer()
	}
}
