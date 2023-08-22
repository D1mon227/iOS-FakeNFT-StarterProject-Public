import UIKit
import SnapKit

final class NFTCardCollectionViewCell: UICollectionViewCell {
    private lazy var nftImage: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 12
        element.layer.masksToBounds = true
        return element
    }()
    
    private lazy var favoriteButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(Resourses.Images.Cell.like, for: .normal)
        element.tintColor = .white
        return element
    }()
    
    private lazy var nftRatingStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 2
        element.distribution = .fillEqually
        return element
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.textAlignment = Locale.current.languageCode == "he" ? .right : .left
        element.font = .bodyBold
        return element
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.textAlignment = Locale.current.languageCode == "he" ? .right : .left
        element.font = .caption3
        return element
    }()
    
    private lazy var addToCartButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(Resourses.Images.Cell.cart, for: .normal)
        element.tintColor = .blackDay
        return element
    }()
    
    private var starImageViews: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupRatingStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(nftImage: URL?,
                       nftName: String?,
                       rating: Int?,
                       nftPrice: String?) {
        guard let nftPrice = nftPrice else { return }
        self.nftImage.setImage(with: nftImage)
        nftNameLabel.text = nftName
        updateRatingStars(rating: rating)
        nftPriceLabel.text = nftPrice + " ETH"
    }
    
    private func setupViews() {
        addSubview(nftImage)
        addSubview(favoriteButton)
        addSubview(nftRatingStack)
        addSubview(nftNameLabel)
        addSubview(nftPriceLabel)
        addSubview(addToCartButton)
        setupConstraints()
    }
    
    private func setupRatingStack() {
        for _ in 0..<5 {
            let imageView = UIImageView(image: Resourses.Images.Cell.star)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(12)
            }
            imageView.tintColor = .yellowUniversal
            nftRatingStack.addArrangedSubview(imageView)
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
            make.height.width.equalTo(108)
            make.top.leading.trailing.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.top.trailing.equalTo(nftImage)
        }
        
        nftRatingStack.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nftImage.snp.bottom).offset(8)
        }
        
        nftNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nftRatingStack.snp.bottom).offset(5)
        }
        
        nftPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nftNameLabel.snp.bottom).offset(4)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.equalToSuperview()
            make.top.equalTo(nftRatingStack.snp.bottom).offset(4)
        }
    }
}
