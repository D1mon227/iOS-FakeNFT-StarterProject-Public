import UIKit

protocol IStatisticsView: AnyObject {
	func setDelegateDataSource()
	func updateUI(with data: [User])
}

final class StatisticsView: UIView {
	var presenter: IStatisticsPresenter?
	var users: [User] = []
	
	private let userStatisticsTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		tableView.backgroundColor = UIColor.backgroundDay
		tableView.showsVerticalScrollIndicator = false
		tableView.register(UserStatisticsCell.self, forCellReuseIdentifier: UserStatisticsCell.identifier)
		return tableView
	}()
	
	private let activityIndicator: UIActivityIndicatorView = {
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
		self.userStatisticsTableView.reloadData()
	}
	
	func setDelegateDataSource() {
		userStatisticsTableView.delegate = self
		userStatisticsTableView.dataSource = self
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

extension StatisticsView: UITableViewDataSource, UITableViewDelegate {
	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: UserStatisticsCell.identifier, for: indexPath) as? UserStatisticsCell else {
			return UITableViewCell()
		}
		let item = users[indexPath.row]
		
		cell.configure(with: item, cellNumber: indexPath.row + 1)
		cell.selectionStyle = .none
		return cell
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = users[indexPath.row]
		presenter?.tapOnTheCell(user: item)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 88
	}
}
