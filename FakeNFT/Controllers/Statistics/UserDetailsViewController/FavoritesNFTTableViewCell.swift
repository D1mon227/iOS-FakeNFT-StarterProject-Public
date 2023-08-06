//
//  FavoritesNFTTableViewCell.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 05.08.2023.
//

import UIKit

final class FavoritesNFTTableViewCell: UITableViewCell {
	static let identifier = "favoritesNFTTableViewCell"
	var onButtonTapped: (() -> Void)?
	
	let disclosureIndicatorImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.tintColor = .black
		return imageView
	}()
	
	lazy var titleFavoritesNFTLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.bodyBold
		label.text = "Коллекция NFT"
		return label
	}()
	
	private lazy var countFavoritesNFTLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.bodyBold
		label.text = "()"
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
		
		contentView.addSubview(self.titleFavoritesNFTLabel)
		contentView.addSubview(self.countFavoritesNFTLabel)
		contentView.addSubview(disclosureIndicatorImageView)
		
		NSLayoutConstraint.activate([
			titleFavoritesNFTLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			titleFavoritesNFTLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			titleFavoritesNFTLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
			
			countFavoritesNFTLabel.leadingAnchor.constraint(equalTo: titleFavoritesNFTLabel.trailingAnchor, constant: 8),
			countFavoritesNFTLabel.centerYAnchor.constraint(equalTo: titleFavoritesNFTLabel.centerYAnchor),
			
			disclosureIndicatorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
