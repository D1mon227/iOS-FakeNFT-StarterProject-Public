//
//  UserStatisticsCell.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 03.08.2023.
//

import UIKit

final class UserStatisticsCell: UITableViewCell {
	
	
	static let identifier = "UserStatisticsCell"
	private var recipeId: Int = 0
	var onButtonTapped: (() -> Void)?
	
	private lazy var cellNumberLabel: UILabel = {
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
		imageView.image = UIImage(named: "profile Image")
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private lazy var userNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.headline3
		return label
	}()
	
	private lazy var nftCountLabel: UILabel = {
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
	
	func getFirstName(from fullName: String) -> String {
		let nameComponents = fullName.components(separatedBy: " ")
		if let firstName = nameComponents.first {
			return firstName
		} else {
			return fullName
		}
	}
	
	func configure(with user: User, cellNumber: Int) {
		cellNumberLabel.text = "\(cellNumber)"
		
		let firstName = getFirstName(from: user.name)
		userNameLabel.text = firstName
		
		nftCountLabel.text = user.rating
		let imageUrlString = user.avatar
		DispatchQueue.global().async {
			if let imageData = try? Data(contentsOf: imageUrlString),
			   let image = UIImage(data: imageData) {
				DispatchQueue.main.async {
					self.userImageView.image = image
				}
			}
		}
	}
}

private extension UserStatisticsCell {
	func configureView() {
		self.backgroundColor = .white
		
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
			containerView.heightAnchor.constraint(equalToConstant: 88),
			
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
		//		let item = searchRecipes[indexPath.row]
		//		presenter?.tapOnTheCell(recipe: item)
	}
}

