import UIKit

protocol IStatisticsView: AnyObject, UITableViewDelegate, UITableViewDataSource {
	func setDelegateDataSource(delegate: UITableViewDelegate & UITableViewDataSource)
	func updateUI(with data: [User])
	func getUsers() -> [User]
	func updateTable()
	var activityIndicator: UIActivityIndicatorView { get }
}

final class StatisticsView: UIView {
	var presenter: StatisticsPresenter?
	var users: [User] = []
	
	lazy var userStatisticsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		tableView.backgroundColor = UIColor.backgroundDay
		tableView.showsVerticalScrollIndicator = false
		tableView.register(UserStatisticsCell.self, forCellReuseIdentifier: UserStatisticsCell.identifier)
		return tableView
	}()
	
	let activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: .large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicator
	}()
	
	init() {
		super.init(frame: .zero)
		self.configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension StatisticsView: IStatisticsView {
	func updateUI(with data: [User]) {
		users = data
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.userStatisticsTableView.reloadData()
		}
	}
	
	func getUsers() -> [User] {
		return users
	}
	
	func setDelegateDataSource(delegate: UITableViewDataSource & UITableViewDelegate) {
		userStatisticsTableView.delegate = delegate
		userStatisticsTableView.dataSource = delegate
	}
	
	func updateTable() {
		userStatisticsTableView.reloadData()
	}
}

private extension StatisticsView {
	func configureView() {
		self.backgroundColor = UIColor.backgroundDay
		self.addSubview(self.userStatisticsTableView)
		self.addSubview(activityIndicator)
		
		NSLayoutConstraint.activate([
			userStatisticsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			userStatisticsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			userStatisticsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			userStatisticsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}
