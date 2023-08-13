protocol IUserDetailsPresenter {
	func viewDidLoad(ui: UserDetailsView)
}

protocol IUserDetailsViewNavigationDelegate: AnyObject {
	func showNFTCollection(with presenter: NFTCollectionPresenter)
}

final class UserDetailsPresenter {
	weak var navigationDelegate: IUserDetailsViewNavigationDelegate?
	private var ui: UserDetailsView?
	private var model: User?
	
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
		self.ui?.setDelegateDataSource()
		guard let user = model else { return }
		self.ui?.updateUI(with: user)
	}
}
