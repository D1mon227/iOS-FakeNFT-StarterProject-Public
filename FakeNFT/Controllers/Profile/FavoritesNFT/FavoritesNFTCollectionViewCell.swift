import UIKit
import SnapKit
import Kingfisher

final class FavoritesNFTCollectionViewCell: UICollectionViewCell {
    private lazy var nftImage: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 12
        element.layer.masksToBounds = true
        return element
    }()
    
    private lazy var favoriteButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(Resourses.Images.Cell.like, for: .normal)
        element.addTarget(self, action: #selector(tappedLike), for: .touchUpInside)
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
    
    private lazy var price: UILabel = {
        let element = UILabel()
        element.font = .caption1
        element.textColor = .blackDay
        element.textAlignment = .left
        return element
    }()
    
    weak var delegate: FavoritesNFTCollectionViewCellDelegate?
    
    private var starImageViews: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupRatingStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tappedLike() {
        delegate?.didTapLike(self)
    }
    
    func configureCell(image: URL?,
                       favoriteButtonColor: UIColor?,
                       nftName: String?,
                       rating: Int?,
                       price: String?) {
        nftImage.kf.setImage(with: image)
        favoriteButton.tintColor = favoriteButtonColor
        nftLabel.text = nftName
        updateRatingStars(rating: rating)
        self.price.text = price
    }
    
    private func setupViews() {
        backgroundColor = .backgroundDay
        addSubview(nftImage)
        addSubview(favoriteButton)
        addSubview(nftLabel)
        addSubview(ratingHorizontalStack)
        addSubview(price)
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
        
        price.snp.makeConstraints { make in
            make.leading.equalTo(nftImage.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-7)
        }
    }
}
