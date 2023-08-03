import UIKit

protocol IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView)
}

final class StatisticsPresenter {
	var ui: IStatisticsView?
	private var model: [User]?
	private let networkClient: NetworkClient
	
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
}

extension StatisticsPresenter: IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView) {
		self.ui = ui
		self.ui?.setDelegateDataSource(delegate: ui)
		guard let users = model else { return }
		self.ui?.updateUI(with: users)
	}
}
