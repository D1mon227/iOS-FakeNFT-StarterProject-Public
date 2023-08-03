import UIKit
import SnapKit

final class FavoritesNFTCollectionViewCell: UICollectionViewCell {
    private let nftImage = UIImageView()
    
    private lazy var favoriteButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(Resourses.Images.Cell.like, for: .normal)
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
    
//    private lazy var ratingStar: UIImageView = {
//        let element = UIImageView()
//        element.image = Resourses.Images.Cell.star
//        return element
//    }()
    
    private lazy var price: UILabel = {
        let element = UILabel()
        element.font = .caption1
        element.textColor = .blackDay
        element.textAlignment = .left
        return element
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(image: UIImage?,
                       favoriteButtonColor: UIColor?,
                       nftName: String?,
                       starColor: UIColor?,
                       price: String?) {
        nftImage.image = image
        favoriteButton.tintColor = favoriteButtonColor
        nftLabel.text = nftName
//        ratingStar.tintColor = starColor
        self.price.text = price
    }
    
    private func setupViews() {
        backgroundColor = .backgroundDay
        addSubview(nftImage)
        addSubview(favoriteButton)
        addSubview(nftLabel)
        addSubview(ratingHorizontalStack)
        setupRatingStack()
//        ratingHorizontalStack.addArrangedSubview(ratingStar)
        addSubview(price)
    }
    
    private func setupRatingStack() {
        for _ in 0..<5 {
            let imageView = UIImageView(image: Resourses.Images.Cell.star)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(12)
            }
            imageView.tintColor = .yellowUniversal
            ratingHorizontalStack.addArrangedSubview(imageView)
        }
    }
    
    private func setupConstraints() {
        nftImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(nftImage).inset(44)
            make.width.height.equalTo(40)
        }
        
        nftLabel.snp.makeConstraints { make in
            make.leading.equalTo(nftImage.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(7)
        }
        
        ratingHorizontalStack.snp.makeConstraints { make in
            make.leading.equalTo(nftImage.snp.trailing).offset(12)
            make.top.equalTo(nftLabel.snp.bottom).offset(4)
        }
        
//        ratingStar.snp.makeConstraints { make in
//            make.width.height.equalTo(12)
//        }
        
        price.snp.makeConstraints { make in
            make.leading.equalTo(nftImage.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-7)
        }
    }
}
