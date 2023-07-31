import UIKit
import SnapKit

final class MyNFTTableViewCell: UITableViewCell {
    private let nftImage = UIImageView()
    
    private lazy var favoriteButton: UIButton = {
        let element = UIButton()
        element.setImage(Resourses.Images.Cell.like, for: .normal)
        return element
    }()
    
    private lazy var nftInfoVerticalStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.alignment = .leading
        element.distribution = .fillProportionally
        element.spacing = 4
        return element
    }()
    
    private lazy var nftLabel: UILabel = {
        let element = UILabel()
        element.font = .bodyBold
        element.textColor = .blackDay
        return element
    }()
    
    private lazy var ratingHorizontalStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .fillEqually
        element.spacing = 2
        return element
    }()
    
    private lazy var ratingStar: UIImageView = {
        let element = UIImageView()
        element.image = Resourses.Images.Cell.star
        return element
    }()
    
    private lazy var authorHorizontalStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.alignment = .firstBaseline
        element.distribution = .fillProportionally
        element.spacing = 4
        return element
    }()
    
    private lazy var fromAuthorLabel: UILabel = {
        let element = UILabel()
        element.font = .caption1
        element.text = LocalizableConstants.Profile.byAuthor
        element.textColor = .blackDay
        return element
    }()
    
    private lazy var authorLabel: UILabel = {
        let element = UILabel()
        element.font = .caption2
        element.textColor = .blackDay
        return element
    }()
    
    private lazy var nftPriceVerticalStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.alignment = .leading
        element.distribution = .fillEqually
        element.spacing = 2
        return element
    }()
    
    private lazy var priceLabel: UILabel = {
        let element = UILabel()
        element.font = .caption2
        element.text = LocalizableConstants.Profile.price
        element.textColor = .blackDay
        return element
    }()
    
    private lazy var price: UILabel = {
        let element = UILabel()
        element.font = .bodyBold
        element.textColor = .blackDay
        return element
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    func configureCell(image: UIImage?,
                       favoriteButtonColor: UIColor?,
                       nftName: String?,
                       starColor: UIColor?,
                       author: String?,
                       price: String?) {
        nftImage.image = image
        favoriteButton.tintColor = favoriteButtonColor
        nftLabel.text = nftName
        ratingStar.tintColor = starColor
        authorLabel.text = author
        self.price.text = price
    }
    
    private func setupViews() {
        backgroundColor = .backgroundDay
        addSubview(nftImage)
        addSubview(favoriteButton)
        addSubview(nftInfoVerticalStack)
        nftInfoVerticalStack.addArrangedSubview(nftLabel)
        nftInfoVerticalStack.addArrangedSubview(ratingHorizontalStack)
        for _ in 0..<5 {
            ratingHorizontalStack.addArrangedSubview(ratingStar)
        }
        nftInfoVerticalStack.addArrangedSubview(authorHorizontalStack)
        authorHorizontalStack.addArrangedSubview(fromAuthorLabel)
        authorHorizontalStack.addArrangedSubview(authorLabel)
        addSubview(nftPriceVerticalStack)
        nftPriceVerticalStack.addArrangedSubview(priceLabel)
        nftPriceVerticalStack.addArrangedSubview(price)
        setupConstraints()
    }
    
    private func setupConstraints() {
        nftImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(108)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.trailing.equalTo(nftImage)
        }
        
        nftInfoVerticalStack.snp.makeConstraints { make in
            make.leading.equalTo(nftImage.snp.trailing).offset(20)
            make.height.equalTo(62)
            make.width.greaterThanOrEqualTo(78)
            make.centerY.equalTo(nftImage)
        }
        
        ratingStar.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
        
        nftPriceVerticalStack.snp.makeConstraints { make in
            make.centerY.equalTo(nftInfoVerticalStack)
            make.leading.equalTo(nftInfoVerticalStack.snp.trailing).offset(39)
        }
    }
}
