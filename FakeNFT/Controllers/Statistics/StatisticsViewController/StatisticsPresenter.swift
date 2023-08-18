import Foundation

protocol IStatisticsPresenter {
	var navigationDelegate: StatisticViewControllerDelegate? { get set }
	func viewDidLoad(ui: IStatisticsView)
	func tapOnTheCell(user: User)
	func sortData(by sortOption: Sort)
	func didTapSortButton()
}

protocol StatisticViewControllerDelegate: AnyObject {
	func showAlert(model: AlertActionSheetModel)
}

final class StatisticsPresenter {
	weak var navigationDelegate: StatisticViewControllerDelegate?
	private weak var ui: IStatisticsView?
	private let networkClient: DefaultNetworkClient?
	private let appCoordinator: AppCoordinator?
	private var currentSortOption: Sort {
		get {
			if let savedSort = UserDefaults.standard.string(forKey: "SavedSortOption") {
				return Sort(rawValue: savedSort) ?? .byRating
			} else {
				return .byRating
			}
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: "SavedSortOption")
		}
	}
	private var model: [User] = []
	
	init(networkClient: DefaultNetworkClient?, appCoordinator: AppCoordinator?) {
		self.networkClient = networkClient
		self.appCoordinator = appCoordinator
	}
	
	func fetchUserFromServer() {
		UIBlockingProgressHUD.show()
		let request = GetUsersRequest()
		networkClient?.send(request: request, type: [User].self) { [weak self] result in
			guard let self else { return }
			UIBlockingProgressHUD.dismiss()
			
			switch result {
			case .success(let users):
				self.model = users
				sortData(by: currentSortOption)
			case .failure(let error):
				print("Error fetching data:", error)
			}
		}
	}
	
	func tapOnTheCell(user: User) {
		appCoordinator?.showUserDetails(user: user)
	}
	
	func didTapSortButton() {
		showSortingOptions()
	}
	
	func showSortingOptions() {
		let sortingOptions: [Sort] = [.byName, .byRating, .close]
		let alertModel = AlertActionSheetModel(title: LocalizableConstants.Sort.sort, actions: sortingOptions) { [weak self] selectedOption in
			self?.sortData(by: selectedOption)
		}
		navigationDelegate?.showAlert(model: alertModel)
	}
	
	func sortData(by sortOption: Sort)  {
		switch sortOption {
		case .byName:
			model.sort { $0.name < $1.name }
			currentSortOption = .byName
		case .byRating:
			model.sort { Int($0.rating) ?? 0 < Int($1.rating) ?? 0 }
			currentSortOption = .byRating
		default:
			print("Не обработал")
		}
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.ui?.updateUI(with: model)
		}
	}
}

extension StatisticsPresenter: IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView) {
		self.ui = ui
		self.ui?.setDelegateDataSource()
		self.ui?.updateUI(with: model)
		fetchUserFromServer()
	}
}
