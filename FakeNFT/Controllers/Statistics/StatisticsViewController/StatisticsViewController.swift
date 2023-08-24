import UIKit

final class StatisticsViewController: UIViewController, StatisticViewControllerDelegate {
	private var statisticsPresenter: IStatisticsPresenter
	private let customView = StatisticsView()
	private let alertService = AlertService()
	private var sortButton: UIBarButtonItem?
	
	init(with presenter: IStatisticsPresenter) {
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
		customView.presenter = statisticsPresenter
		statisticsPresenter.navigationDelegate = self
		configureNavigationBar()
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.statisticsPresenter.viewDidLoad(ui: self.customView)
    }
	
	func showAlert(model: AlertSortModel) {
		alertService.showSortAlert(model: model, controller: self)
	}
}

private extension StatisticsViewController {
	func configureNavigationBar() {
		let customBarButtonItem = UIBarButtonItem(image: Resourses.Images.Sort.sort, style: .plain, target: self, action: #selector(sortButtonTapped))
		customBarButtonItem.tintColor = UIColor.blackDay
		navigationItem.rightBarButtonItem = customBarButtonItem
	}
	
	@objc func sortButtonTapped() {
		statisticsPresenter.didTapSortButton()
	}
}
