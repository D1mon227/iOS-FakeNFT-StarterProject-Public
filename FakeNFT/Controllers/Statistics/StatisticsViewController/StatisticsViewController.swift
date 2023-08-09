import UIKit

final class StatisticsViewController: UIViewController, IStatisticsViewNavigationDelegate {
	private let customView = StatisticsView()
	private var sortButton: UIBarButtonItem?
	var statisticsPresenter: StatisticsPresenter
	let alertService = AlertService()
	
	
	var users: [User] = []
	
	init(with presenter: StatisticsPresenter) {
			self.statisticsPresenter = presenter
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
		self.statisticsPresenter.viewDidLoad(ui: self.customView)
		customView.presenter = statisticsPresenter
		statisticsPresenter.navigationDelegate = self
		configureNavigationBar()
		self.statisticsPresenter.fetchDataFromServer()
	}
	
	func showUserDetails(with presenter: UserDetailsPresenter) {
		let userDetailsViewController = UserDetailsViewController(with: presenter)
		navigationController?.pushViewController(userDetailsViewController, animated: true)
	}
}

private extension StatisticsViewController {
	func configureNavigationBar() {
		let customBarButtonItem = UIBarButtonItem(image: Resourses.Images.Sort.sort, style: .plain, target: self, action: #selector(sortButtonTapped))
		customBarButtonItem.tintColor = UIColor.blackDay
		navigationItem.rightBarButtonItem = customBarButtonItem
	}
	
	func showSortingOptions() {
		let sortingOptions: [Sort] = [.byName, .byRating, .close]
		
		let users = statisticsPresenter.ui?.getUsers()
		if let users = users {
			alertService.showAlert(title: LocalizableConstants.Sort.sort, actions: sortingOptions, controller: self) { [self] selectedOption in
				let sortedData = statisticsPresenter.sortData(by: selectedOption, dataToSort: users)
				statisticsPresenter.ui?.updateUI(with: sortedData)
			}
		} else {
			print("Error: Users data is not available.")
		}
	}
	
	
	@objc func sortButtonTapped() {
		showSortingOptions()
	}
}
