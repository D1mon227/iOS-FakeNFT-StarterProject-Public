import UIKit

final class NFTCardView {
    lazy var generalScrollView: UIScrollView = {
        let element = UIScrollView()
        element.showsVerticalScrollIndicator = false
        element.contentInsetAdjustmentBehavior = .never
        return element
    }()
    
    lazy var coverNFTScrollView: UIScrollView = {
        let element = UIScrollView()
        element.isPagingEnabled = true
        element.showsHorizontalScrollIndicator = false
        return element
    }()
    
    lazy var firstNFTCover: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 40
        element.layer.masksToBounds = true
        element.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return element
    }()
    
    lazy var secondNFTCover: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 40
        element.layer.masksToBounds = true
        element.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return element
    }()
    
    lazy var thirdNFTCover: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 40
        element.layer.masksToBounds = true
        element.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return element
    }()
    
    lazy var pageControlView = UIView()
    
    lazy var coverPageControlStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 8
        element.distribution = .fillProportionally
        return element
    }()
    
    lazy var nftLabel: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.font = .headline3
        return element
    }()
    
    lazy var nftRatingStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 2
        element.distribution = .fillEqually
        return element
    }()
    
    lazy var nftCollectionLabel: UILabel = {
        let element = UILabel()
        element.text = "Peach"
        element.textColor = .blackDay
        element.font = .bodyBold
        return element
    }()
    
    lazy var priceLabel: UILabel = {
        let element = UILabel()
        element.text = LocalizableConstants.NFTCard.price
        element.textColor = .blackDay
        element.font = .caption1
        return element
    }()
    
    lazy var price: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.font = .bodyBold
        return element
    }()
    
    lazy var addToCartButton: UIButton = {
        let element = UIButton(type: .system)
        element.backgroundColor = .blackDay
        element.setTitleColor(.backgroundDay, for: .normal)
        element.setTitle(LocalizableConstants.NFTCard.addToCart, for: .normal)
        element.layer.cornerRadius = 16
        element.titleLabel?.font = .bodyBold
        return element
    }()
    
    lazy var currencyTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.backgroundColor = .lightGreyDay
        element.layer.cornerRadius = 12
        element.isScrollEnabled = false
        return element
    }()
    
    lazy var sellerWebsiteButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(LocalizableConstants.NFTCard.sellerWebsite, for: .normal)
        element.titleLabel?.font = .caption1
        element.setTitleColor(.blackDay, for: .normal)
        element.layer.cornerRadius = 16
        element.layer.borderWidth = 1
        return element
    }()
    
    lazy var nftCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let element = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        element.backgroundColor = .backgroundDay
        element.showsHorizontalScrollIndicator = false
        return element
    }()
}
