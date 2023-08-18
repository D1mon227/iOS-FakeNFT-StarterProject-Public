//
//  UserStatisticsCell.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 03.08.2023.
//

import UIKit
import Kingfisher

final class UserStatisticsCell: UITableViewCell {
	static let identifier = "userStatisticsCell"
	
	private let cellNumberLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.caption1
		return label
	}()
	
	private let containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor.lightGreyDay
		view.layer.cornerRadius = 12
		view.layer.masksToBounds = false
		return view
	}()
	
	private let userImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 14
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let userNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.headline3
		return label
	}()
	
	private let nftCountLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.headline3
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with user: User, cellNumber: Int) {
		cellNumberLabel.text = "\(cellNumber)"
		userNameLabel.text = user.firstName
		nftCountLabel.text = user.rating
		
		if let imageUrl = user.avatar {
			userImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholderImage"))
		} else {
			userImageView.image = UIImage(named: "placeholderImage")
		}
	}
}

private extension UserStatisticsCell {
	func configureView() {
		self.backgroundColor = UIColor.backgroundDay
		contentView.addSubview(containerView)
		contentView.addSubview(cellNumberLabel)
		containerView.addSubview(userImageView)
		containerView.addSubview(userNameLabel)
		containerView.addSubview(nftCountLabel)
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			
			cellNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			cellNumberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			
			userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
			userImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			userImageView.widthAnchor.constraint(equalToConstant: 28),
			userImageView.heightAnchor.constraint(equalToConstant: 28),
			
			userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
			userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
			
			nftCountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
			nftCountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
		])
	}
}
