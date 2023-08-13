protocol IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView)
	func navigateToUserDetails(with presenter: UserDetailsPresenter)
}

protocol IStatisticsViewNavigationDelegate: AnyObject {
	func showUserDetails(with presenter: UserDetailsPresenter)
}

final class StatisticsPresenter {
	weak var navigationDelegate: IStatisticsViewNavigationDelegate?
	private var model: [User]?
	private var ui: IStatisticsView?
	private let networkClient = DefaultNetworkClient()
	
	func fetchUserFromServer() {
		self.ui?.activatedIndicator()
		let request = GetUsersRequest()
		networkClient.send(request: request, type: [User].self) { [weak self] result in
			guard let self else { return }
			self.ui?.deactivatedIndicator()
			
			switch result {
			case .success(let users):
				self.model = users
				sortData(by: .byRating)
			case .failure(let error):
				print("Error fetching data:", error)
			}
		}
	}
	
	func tapOnTheCell(user: User?) {
		if let user = user {
			let userDetailsPresenter = UserDetailsPresenter(user: user)
			self.navigateToUserDetails(with: userDetailsPresenter)
		}
	}
	
	func navigateToUserDetails(with presenter: UserDetailsPresenter) {
		navigationDelegate?.showUserDetails(with: presenter)
	}
	
	func sortData(by: Sort)  {
		guard var dataToSort = model else { return }
		
		switch by {
		case .byName:
			dataToSort.sort { $0.name < $1.name }
		case .byRating:
			dataToSort.sort { Int($0.rating) ?? 0 < Int($1.rating) ?? 0 }
		default:
			break
		}
		
		ui?.updateUI(with: dataToSort)
	}
}

extension StatisticsPresenter: IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView) {
		self.ui = ui
		self.ui?.setDelegateDataSource()
		guard let users = model else { return }
		self.ui?.updateUI(with: users)
	}
}
