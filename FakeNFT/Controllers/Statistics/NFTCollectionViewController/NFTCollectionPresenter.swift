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
}

extension NFTCollectionPresenter: INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView) {
		self.ui = ui
		self.ui?.setDelegateDataSource(delegate: ui)
	}
}
