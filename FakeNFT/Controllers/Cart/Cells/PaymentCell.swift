//
//  PaymentCell.swift
//  FakeNFT
//
//  Created by Денис on 08.08.2023.
//

import UIKit

final class PaymentCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        return view
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let shortName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.11, green: 0.62, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 1
                layer.borderColor = UIColor.blackDay.cgColor
                layer.backgroundColor = UIColor.lightGreyDay.cgColor
            } else {
                layer.borderWidth = 0
                layer.backgroundColor = UIColor.clear.cgColor // Set the default background color
                layer.backgroundColor = UIColor.lightGreyDay.cgColor
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        backgroundColor = .lightGreyDay
        NSLayoutConstraint.activate([
            imageBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: 36),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 36),
            image.widthAnchor.constraint(equalToConstant: 36),
            name.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 4),
            name.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            shortName.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 4),
            shortName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    private func setupProperties() {
        layer.cornerRadius = 12
        addSubview(imageBackgroundView)
        addSubview(image)
        addSubview(name)
        addSubview(shortName)
    }
    
}
