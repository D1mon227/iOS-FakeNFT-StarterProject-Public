import UIKit
import Kingfisher

struct NFTCollectionViewCellViewModel {
    let nftId: String
    let nftIcon: String?
    let nftStarsCount: Int
    let nftName: String
    let nftPrice: String
    let isFavorite: Bool
    
    init(nftResponse: NftResponse) {
        self.nftId = nftResponse.id
        self.nftIcon = nftResponse.images.first
        self.nftStarsCount = nftResponse.rating
        self.nftName = nftResponse.name
        self.isFavorite = false
        self.nftPrice = String(nftResponse.price)
    }
    
    init(nftId: String,
         nftIcon: String?,
         nftStarsCount: Int,
         nftName: String,
         nftPrice: String,
         isFavorite: Bool) {
        self.nftId = nftId
        self.nftIcon = nftIcon
        self.nftStarsCount = nftStarsCount
        self.nftName = nftName
        self.isFavorite = isFavorite
        self.nftPrice = nftPrice
    }
    
    func makeNewModel(isFavorite: Bool) -> NFTCollectionViewCellViewModel {
        return NFTCollectionViewCellViewModel(nftId: self.nftId,
                                              nftIcon: self.nftIcon,
                                              nftStarsCount: self.nftStarsCount,
                                              nftName: self.nftName,
                                              nftPrice: self.nftPrice,
                                              isFavorite: isFavorite)
    }
}

final class NFTCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Layout elements
    
    private let nftIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nftStarsCount: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    
    private let nftPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    
    private let nftLikeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let nftCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let commonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCommonView()
        setupNFTCollectionViewConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: NFTCollectionViewCellViewModel) {
//        nftIcon.kf.se
        nftNameLabel.text = viewModel.nftName
        nftPriceLabel.text = viewModel.nftPrice
        if viewModel.isFavorite {
//            nftLikeButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        } else {
            //            nftLikeButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        }
    }
    
}

extension NFTCollectionViewCell {
    
    // MARK: - Layout methods
    
    func setupCommonView() {
//        commonView.addSubview(<#T##view: UIView##UIView#>)
    }
    
    func setupNFTCollectionViewConstrains() {
        NSLayoutConstraint.activate([
            //commonView
            
            //nftIcon
            
            //nftStarsCount
            
            //nftNameLabel
            
            //nftPriceLabel
            
            //nftLikeButton
            
            //nftCartButton
            
        ])
    }
}

