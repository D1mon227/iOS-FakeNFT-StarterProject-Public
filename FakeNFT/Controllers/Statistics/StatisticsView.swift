import UIKit

protocol IStatisticsView: AnyObject {
}

final class StatisticsView: UIView {
	init() {
		super.init(frame: .zero)
		self.configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension StatisticsView: IStatisticsView {
}

private extension StatisticsView {
	func configureView() {
		self.backgroundColor = UIColor.backgroundDay
	}
}
