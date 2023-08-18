import UIKit

protocol IUserDetailsView: AnyObject {
	func setDelegateDataSource()
	func updateUI(with data: User)
}

final class UserDetailsView: UIView {
	let cellTitles = [LocalizableConstants.Statistics.nftCollection]
	var presenter: IUserDetailsPresenter?
	weak var navigationController: UINavigationController?
	var user: User?
	
	private let userImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 35
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let userNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.headline3
		return label
	}()
	
	private let userDescriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.caption2
		label.numberOfLines = 0
		return label
	}()
	
	private lazy var websiteUserButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle(LocalizableConstants.Statistics.userWebsite, for: .normal)
		button.setTitleColor(.blackDay, for: .normal)
		button.titleLabel?.font = UIFont.caption1
		button.layer.cornerRadius = 16
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.blackDay.cgColor
		button.addTarget(self, action: #selector(websiteUserButtonTapped), for: .touchUpInside)
		return button
	}()
	
	private let favoritesNFTTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		tableView.isScrollEnabled = false
		tableView.backgroundColor = UIColor.backgroundDay
		tableView.showsVerticalScrollIndicator = false
		tableView.register(FavoritesNFTTableViewCell.self, forCellReuseIdentifier: FavoritesNFTTableViewCell.identifier)
		return tableView
	}()
	
	init() {
		super.init(frame: .zero)
		self.configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		websiteUserButton.layer.borderColor = UIColor.blackDay.cgColor
	}
	
	func configure() {
		if let imageUrl = user?.avatar {
			userImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholderImage"))
		} else {
			userImageView.image = UIImage(named: "placeholderImage")
		}
		
		userNameLabel.text = user?.name
		userDescriptionLabel.text = user?.description
	}
	
	@objc private func websiteUserButtonTapped(_ sender: UIButton) {
		guard let url = user?.website else { return }
		let request = URLRequest(url: url)
		presenter?.appCoordinator.showWebViewScreen(url: request)
	}
}

extension UserDetailsView: IUserDetailsView {
	func updateUI(with data: User) {
		user = data
		configure()
	}
	
	func setDelegateDataSource() {
		favoritesNFTTableView.delegate = self
		favoritesNFTTableView.dataSource = self
	}
}

private extension UserDetailsView {
	func configureView() {
		self.backgroundColor = UIColor.backgroundDay
		self.addSubview(self.userImageView)
		self.addSubview(self.userNameLabel)
		self.addSubview(self.userDescriptionLabel)
		self.addSubview(self.websiteUserButton)
		self.addSubview(self.favoritesNFTTableView)
		
		NSLayoutConstraint.activate([
			userImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
			userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			userImageView.widthAnchor.constraint(equalToConstant: 70),
			userImageView.heightAnchor.constraint(equalToConstant: 70),
			
			userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
			userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
			userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			
			userDescriptionLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
			userDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			userDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
			
			websiteUserButton.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 28),
			websiteUserButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			websiteUserButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			websiteUserButton.heightAnchor.constraint(equalToConstant: 40),
			
			favoritesNFTTableView.topAnchor.constraint(equalTo: websiteUserButton.bottomAnchor, constant: 40),
			favoritesNFTTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			favoritesNFTTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			favoritesNFTTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
		])
	}
}

extension UserDetailsView: UITableViewDataSource, UITableViewDelegate {
	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellTitles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesNFTTableViewCell.identifier, for: indexPath) as? FavoritesNFTTableViewCell else {
			return UITableViewCell()
		}
		cell.titleFavoritesNFTLabel.text = cellTitles[indexPath.row]
		if let user = user {
			cell.configure(with: user)
		}
		
		cell.selectionStyle = .none
		return cell
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selectedUser = user else { return }
		presenter?.tapOnTheCell(user: selectedUser)
	}
}
