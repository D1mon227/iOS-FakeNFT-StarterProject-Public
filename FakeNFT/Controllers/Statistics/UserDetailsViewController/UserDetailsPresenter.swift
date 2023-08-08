protocol IUserDetailsPresenter {
	func viewDidLoad(ui: UserDetailsView)
}

protocol IUserDetailsViewNavigationDelegate: AnyObject {
	func showNFTCollection(with presenter: NFTCollectionPresenter)
}

final class UserDetailsPresenter {
	var ui: UserDetailsView?
	private var model: User?
	weak var navigationDelegate: IUserDetailsViewNavigationDelegate?
	
	init(user: User?) {
		self.model = user
	}
	
	func tapOnTheCell(user: User?) {
		let nftCollectionPresenter = NFTCollectionPresenter()
		navigationDelegate?.showNFTCollection(with: nftCollectionPresenter)
		if let nftIds = user?.nfts {
			nftCollectionPresenter.fetchNFTsForUser(nftIds: nftIds)
		}
	}
}

extension UserDetailsPresenter: IUserDetailsPresenter {
	func viewDidLoad(ui: UserDetailsView) {
		self.ui = ui
		self.ui?.setDelegateDataSource(delegate: ui)
		guard let user = model else { return }
		self.ui?.updateUI(with: user)
	}
}
