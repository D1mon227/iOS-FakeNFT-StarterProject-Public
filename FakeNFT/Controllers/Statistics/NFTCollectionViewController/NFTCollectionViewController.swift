import UIKit

final class NFTCollectionViewController: UIViewController {
	private let customView = NFTCollectionView()
	private let nftCollectionPresenter: INFTCollectionPresenter
	
	init(with presenter: INFTCollectionPresenter) {
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
	}
}

private extension NFTCollectionViewController {
	func setupNavigationController() {
		navigationItem.title = LocalizableConstants.Statistics.nftCollection
	}
}
