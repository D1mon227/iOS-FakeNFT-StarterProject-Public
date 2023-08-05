import UIKit

protocol INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView)
}

final class NFTCollectionPresenter {
	var ui: NFTCollectionView?
	
}

extension NFTCollectionPresenter: INFTCollectionPresenter {
	func viewDidLoad(ui: NFTCollectionView) {
		self.ui = ui

	}
}
