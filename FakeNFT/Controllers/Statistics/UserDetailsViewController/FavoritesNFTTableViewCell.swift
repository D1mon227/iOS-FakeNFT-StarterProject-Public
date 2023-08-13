//
//  FavoritesNFTTableViewCell.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 05.08.2023.
//

import UIKit

final class FavoritesNFTTableViewCell: UITableViewCell {
	static let identifier = "favoritesNFTTableViewCell"
	
	private let containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.masksToBounds = false
		return view
	}()
	
	private let disclosureIndicatorImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.tintColor = .blackDay
		return imageView
	}()
	
	private let countFavoritesNFTLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.bodyBold
		return label
	}()
	
	let titleFavoritesNFTLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.bodyBold
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with user: User) {
		countFavoritesNFTLabel.text = "(\(user.nfts.count))"
	}
}

private extension FavoritesNFTTableViewCell {
	func configureView() {
		self.backgroundColor = UIColor.backgroundDay
		
		contentView.addSubview(self.containerView)
		containerView.addSubview(titleFavoritesNFTLabel)
		containerView.addSubview(countFavoritesNFTLabel)
		containerView.addSubview(disclosureIndicatorImageView)
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			containerView.heightAnchor.constraint(equalToConstant: 54),
			
			titleFavoritesNFTLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			titleFavoritesNFTLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
			
			countFavoritesNFTLabel.leadingAnchor.constraint(equalTo: titleFavoritesNFTLabel.trailingAnchor, constant: 8),
			countFavoritesNFTLabel.centerYAnchor.constraint(equalTo: titleFavoritesNFTLabel.centerYAnchor),
			
			disclosureIndicatorImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
			disclosureIndicatorImageView.centerYAnchor.constraint(equalTo: titleFavoritesNFTLabel.centerYAnchor)
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
