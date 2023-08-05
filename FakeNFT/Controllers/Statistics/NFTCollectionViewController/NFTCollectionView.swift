import UIKit

protocol INFTCollectionView: AnyObject {
	
}

final class NFTCollectionView: UIView {
	
	
	
	init() {
		super.init(frame: .zero)
		self.configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension NFTCollectionView: INFTCollectionView {
	
	
	
}

private extension NFTCollectionView {
	func configureView() {
//		self.backgroundColor = UIColor.backgroundDay
//		self.addSubview(self.userStatisticsTableView)
//		self.addSubview(activityIndicator)
//
//		NSLayoutConstraint.activate([
//			userStatisticsTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//			userStatisticsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
//			userStatisticsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
//			userStatisticsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
//
//			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//			activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//		])
	}
}
