protocol IUserDetailsPresenter {
	func viewDidLoad(ui: UserDetailsView)
	func tapOnTheCell(user: User)
}

final class UserDetailsPresenter {
	private weak var ui: UserDetailsView?
	private let appCoordinator: AppCoordinator?
	private var model: User?
	
	init(model: User?, appCoordinator: AppCoordinator?) {
		self.model = model
		self.appCoordinator = appCoordinator
	}
	
	func tapOnTheCell(user: User) {
		appCoordinator?.showNFTCollectionScreen(user: user)
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
