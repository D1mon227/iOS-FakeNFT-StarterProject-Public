//
//  NFTCollectionCell.swift
//  FakeNFT
//
//  Created by Артем Крикуненко on 05.08.2023.
//

import UIKit
import Kingfisher

final class NFTCollectionCell: UICollectionViewCell {
	static let identifier = "NFTCollectionCell"
	var onCartButtonTapped: (() -> Void)?
	var onFavoriteButtonTapped: (() -> Void)?
	
	private let containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.masksToBounds = false
		return view
	}()
	
	private let nftImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.distribution = .equalSpacing
		stackView.spacing = 2
		return stackView
	}()
	
	private let nftRatingImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private let nftNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.bodyBold
		return label
	}()
	
	private let nftPriceLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.caption3
		return label
	}()
	
	lazy var favoritesButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(Resourses.Images.Cell.like, for: .normal)
		button.tintColor = UIColor.white
		button.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
		return button
	}()
	
	lazy var cartButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(Resourses.Images.Cell.cart, for: .normal)
		button.tintColor = UIColor.blackDay
		button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
		return button
	}()
	
	@objc
	private func favoritesButtonTapped(_ sender: UIButton) {
		onFavoriteButtonTapped?()
	}
	
	@objc
	private func cartButtonTapped(_ sender: UIButton) {
		onCartButtonTapped?()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with nft: NFT, likes: Likes?, order: Order?) {
		if let imageUrl = nft.images {
			nftImageView.kf.setImage(with: imageUrl.first)
		}
		configureFavoritesButton(for: nft, likes: likes)
		configureCartButton(for: nft, order: order)
		
		removeRatingStars()
		setRatingStars(rating: nft.rating)
		nftNameLabel.text = nft.name
		let formattedPrice = String(format: "%.2f ETH", nft.price).replacingOccurrences(of: ".", with: ",")
		nftPriceLabel.text = formattedPrice
	}
	
	private func configureFavoritesButton(for nft: NFT, likes: Likes?) {
		if let profileLikes = likes, profileLikes.likes.contains(nft.id) {
			favoritesButton.tintColor = .redUniversal
		} else {
			favoritesButton.tintColor = UIColor.white
		}
	}

	private func configureCartButton(for nft: NFT, order: Order?) {
		if let order = order, order.nfts.contains(nft.id) {
			cartButton.setImage(Resourses.Images.Cell.cartFill, for: .normal)
		} else {
			cartButton.setImage(Resourses.Images.Cell.cart, for: .normal)
		}
	}
	
	private func setRatingStars(rating: Int) {
		let imageCount = 5
		
		for i in 0..<imageCount {
			let imageView = UIImageView(image: Resourses.Images.Cell.star)
			imageView.tintColor = .gray
			imageView.contentMode = .scaleAspectFit
			imageView.translatesAutoresizingMaskIntoConstraints = false
			imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
			imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
			
			if i < rating {
				imageView.tintColor = .yellowUniversal
			} else {
				imageView.tintColor = .lightGreyDay
			}
			
			stackView.addArrangedSubview(imageView)
		}
	}
	
	private func removeRatingStars() {
		for subview in stackView.arrangedSubviews {
			stackView.removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}
	}
}

private extension NFTCollectionCell {
	func configureView() {
		self.backgroundColor = UIColor.backgroundDay
		
		contentView.addSubview(containerView)
		containerView.addSubview(nftImageView)
		containerView.addSubview(stackView)
		containerView.addSubview(nftNameLabel)
		containerView.addSubview(nftPriceLabel)
		containerView.addSubview(favoritesButton)
		containerView.addSubview(cartButton)
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			
			nftImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
			nftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			nftImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			nftImageView.heightAnchor.constraint(equalToConstant: 108),
			nftImageView.widthAnchor.constraint(equalToConstant: 108),
			
			favoritesButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
			favoritesButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
			favoritesButton.heightAnchor.constraint(equalToConstant: 42),
			favoritesButton.widthAnchor.constraint(equalToConstant: 42),
			
			cartButton.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 24),
			cartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
			cartButton.heightAnchor.constraint(equalToConstant: 40),
			cartButton.widthAnchor.constraint(equalToConstant: 40),
			
			stackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
			stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			
			nftNameLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
			nftNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			
			nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
			nftPriceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
		])
	}
}

extension NFTCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
	
	// MARK: - UITableViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionNFT.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionCell.identifier, for: indexPath) as? NFTCollectionCell else {
			return UICollectionViewCell()
		}
		let nft = collectionNFT[indexPath.row]
		cell.configure(with: nft, likes: likes, order: order)
		
		if let id = order?.id {
			cell.onCartButtonTapped = {
				self.presenter?.tapOnTheCell(for: nft.id, profile: id)
			}
			
			cell.onFavoriteButtonTapped = {
				self.presenter?.tapOnTheCell(for: nft.id)
			}
		}
		return cell
	}
}
