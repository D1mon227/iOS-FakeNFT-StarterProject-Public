import UIKit

final class NFTCollectionViewController: UIViewController {
	private let customView = NFTCollectionView()
	var nftCollectionPresenter: NFTCollectionPresenter
	
	init(with presenter: NFTCollectionPresenter) {
		self.nftCollectionPresenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		self.view = self.customView
		setupNavigationController()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.nftCollectionPresenter.viewDidLoad(ui: self.customView)
		customView.presenter = nftCollectionPresenter
		self.nftCollectionPresenter.fetchLikesFromServer()
		self.nftCollectionPresenter.fetchOrdersFromServer()
	}
	
	func showNFTCollection(with presenter: NFTCollectionPresenter) {
		let nftCollectionViewController = NFTCollectionViewController(with: presenter)
		navigationController?.pushViewController(nftCollectionViewController, animated: true)
	}
}

private extension NFTCollectionViewController {
	func setupNavigationController() {
		navigationItem.title = LocalizableConstants.Statistics.nftCollection
	}
}
