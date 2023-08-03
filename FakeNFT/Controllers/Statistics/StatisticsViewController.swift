import UIKit

final class StatisticsViewController: UIViewController {
	private let customView = StatisticsView()
	var statisticsPresenter: StatisticsPresenter
	
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
		self.statisticsPresenter.fetchDataFromServer()
	}
}
