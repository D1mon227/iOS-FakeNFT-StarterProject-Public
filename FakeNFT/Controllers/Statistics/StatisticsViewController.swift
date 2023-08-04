import UIKit

final class StatisticsViewController: UIViewController {
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
		configureNavigationBar()
		self.statisticsPresenter.fetchDataFromServer()
	}
}

private extension StatisticsViewController {
	func configureNavigationBar() {
		sortButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sortButtonTapped))
		navigationItem.rightBarButtonItem = sortButton
	}
	
	func showSortingOptions() {
		let sortingOptions: [Sort] = [.byName, .byRating, .close]

		let users = statisticsPresenter.ui?.getUsers()
		if let users = users {
			alertService.showAlert(title: "Сортировка", actions: sortingOptions, controller: self) { [self] selectedOption in
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
