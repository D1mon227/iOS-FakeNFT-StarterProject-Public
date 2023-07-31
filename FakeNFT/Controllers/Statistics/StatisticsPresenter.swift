protocol IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView)
}

final class StatisticsPresenter {
	var ui: IStatisticsView?
}

extension StatisticsPresenter: IStatisticsPresenter {
	func viewDidLoad(ui: IStatisticsView) {
		self.ui = ui
	}
}
