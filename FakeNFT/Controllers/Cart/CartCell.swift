//
//  CartCell.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//


import UIKit

/// Delegate
protocol CartCellDelegate {
    
    func showDeleteView(index: Int)
    
}

final class CartCell: UITableViewCell {
    
    // MARK: - Properties & Init
    var delegate: CartCellDelegate?
    
    var indexCell: Int?
    
    let nftImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.image = UIImage(systemName: "photo")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nftName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nftPriceTitle: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nftPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "star")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let starStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CartDeleteIcon"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions & Methods
    
    private func setupView() {
        contentView.addSubview(nftImage)
        contentView.addSubview(nftName)
        contentView.addSubview(starStack)
        contentView.addSubview(nftPriceTitle)
        contentView.addSubview(nftPrice)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nftName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nftName.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            nftName.widthAnchor.constraint(equalToConstant: 100),
            
            starStack.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: 4),
            starStack.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            nftPriceTitle.topAnchor.constraint(equalTo: starStack.bottomAnchor, constant: 12),
            nftPriceTitle.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            nftPriceTitle.widthAnchor.constraint(equalToConstant: 100),
            
            nftPrice.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            nftPrice.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            nftPrice.heightAnchor.constraint(equalToConstant: 22),
            nftPrice.widthAnchor.constraint(equalToConstant: 100),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // Setting up the rating
    func setupRating(rating: Int) {
        for arrangedSubview in starStack.arrangedSubviews {
            starStack.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        for _ in 0..<rating {
            let starImageView = UIImageView(image: UIImage(named: "star"))
            starImageView.tintColor = .systemYellow
            starStack.addArrangedSubview(starImageView)
        }
        
        let emptyStarsCount = 5 - rating
        for _ in 0..<emptyStarsCount {
            let emptyStarImageView = UIImageView(image: UIImage(named: "grayStar"))
            emptyStarImageView.tintColor = .gray
            starStack.addArrangedSubview(emptyStarImageView)
        }
    }
    
    @objc
    func deleteButtonTapped() {
        delegate?.showDeleteView(index: indexCell ?? 0)
    }
    
}
