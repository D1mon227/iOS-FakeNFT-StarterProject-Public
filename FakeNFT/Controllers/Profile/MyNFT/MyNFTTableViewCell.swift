import UIKit
import Kingfisher
import SnapKit

final class MyNFTTableViewCell: UITableViewCell {
    private lazy var nftImage: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 12
        element.layer.masksToBounds = true
        return element
    }()
    
    private lazy var favoriteButton: UIButton = {
        let element = UIButton(type: .system)
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
    
    private var starImageViews: [UIImageView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupRatingStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(image: URL?,
                       doesNftHasLike: Bool?,
                       nftName: String?,
                       rating: Int?,
                       author: String?,
                       price: String?) {
        nftImage.setImage(with: image)
        if doesNftHasLike == true {
            favoriteButton.tintColor = .redUniversal
        } else {
            favoriteButton.tintColor = .white
        }
        nftLabel.text = nftName
        updateRatingStars(rating: rating)
        authorLabel.text = author
        self.price.text = price
    }
    
    private func setupViews() {
        backgroundColor = .backgroundDay
        contentView.addSubview(nftImage)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(nftInfoVerticalStack)
        nftInfoVerticalStack.addArrangedSubview(nftLabel)
        nftInfoVerticalStack.addArrangedSubview(ratingHorizontalStack)
        nftInfoVerticalStack.addArrangedSubview(authorHorizontalStack)
        authorHorizontalStack.addArrangedSubview(fromAuthorLabel)
        authorHorizontalStack.addArrangedSubview(authorLabel)
        contentView.addSubview(nftPriceVerticalStack)
        nftPriceVerticalStack.addArrangedSubview(priceLabel)
        nftPriceVerticalStack.addArrangedSubview(price)
        setupConstraints()
    }
    
    private func setupRatingStack() {
        for _ in 0..<5 {
            let imageView = UIImageView(image: Resourses.Images.Cell.star)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(12)
            }
            imageView.tintColor = .lightGreyDay
            ratingHorizontalStack.addArrangedSubview(imageView)
            starImageViews.append(imageView)
        }
    }
    
    private func updateRatingStars(rating: Int?) {
        guard let rating = rating else { return }
        
        for i in 0..<5 {
            starImageViews[i].tintColor = i < rating ? .yellowUniversal : .lightGreyDay
        }
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
        
        nftPriceVerticalStack.snp.makeConstraints { make in
            make.centerY.equalTo(nftInfoVerticalStack)
            make.leading.equalTo(nftInfoVerticalStack.snp.trailing).offset(39)
        }
    }
}
