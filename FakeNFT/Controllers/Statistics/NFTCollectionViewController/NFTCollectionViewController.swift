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
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.nftCollectionPresenter.viewDidLoad(ui: self.customView)
	}
}
