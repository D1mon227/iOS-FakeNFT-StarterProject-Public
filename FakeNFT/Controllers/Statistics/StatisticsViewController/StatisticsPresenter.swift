import UIKit

protocol IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView)
	func navigateToUserDetails(with presenter: UserDetailsPresenter)
}

protocol IStatisticsViewNavigationDelegate: AnyObject {
	func showUserDetails(with presenter: UserDetailsPresenter)
}

final class StatisticsPresenter {
	var ui: IStatisticsView?
	private var model: [User]?
	private let networkClient: NetworkClient
	weak var navigationDelegate: IStatisticsViewNavigationDelegate?
	
	init(networkClient: NetworkClient) {
		self.networkClient = networkClient
	}
	
	func fetchDataFromServer() {
		self.ui?.activityIndicator.startAnimating()
		let request = GetUsersRequest()
		networkClient.send(request: request, type: [User].self) { [weak self] result in
			guard let self else { return }
			DispatchQueue.main.async {
				self.ui?.activityIndicator.stopAnimating()
			}
			switch result {
			case let .success(users):
				self.model = users
				if let ui = self.ui, let model = self.model {
					ui.updateUI(with: model)
				}
			case let .failure(error):
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
	
	func sortData(by sortingOption: Sort, dataToSort: [User]) -> [User] {
		switch sortingOption {
		case .byName:
			return dataToSort.sorted { $0.name < $1.name }
		case .byRating:
			return dataToSort.sorted { $0.rating > $1.rating }
		default:
			return dataToSort
		}
	}
}

extension StatisticsPresenter: IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView) {
		self.ui = ui
		self.ui?.setDelegateDataSource(delegate: ui)
		guard let users = model else { return }
		self.ui?.updateUI(with: users)
	}
}
