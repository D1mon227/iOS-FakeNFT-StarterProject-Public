import UIKit

final class StatisticsViewController: UIViewController, IStatisticsViewNavigationDelegate {
	private let statisticsPresenter: StatisticsPresenter
	private let customView = StatisticsView()
	private let alertService = AlertService()
	private var sortButton: UIBarButtonItem?
	
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
		statisticsPresenter.fetchUserFromServer()
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
		alertService.showAlert(title: LocalizableConstants.Sort.sort, actions: sortingOptions, controller: self) { [weak self] selectedOption in
			self!.statisticsPresenter.sortData(by: selectedOption)
		}
	}
	
	@objc func sortButtonTapped() {
		showSortingOptions()
	}
}
