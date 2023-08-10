import UIKit
import Kingfisher

struct NFTCollectionViewCellViewModel {
    let nftIcon: String?
    let nftStarsCount: Int
    let nftName: String
    let nftPrice: String
    let isFavorite: Bool
    
    init(nftResponse: NftResponse) {
        self.nftIcon = nftResponse.images.first
        self.nftStarsCount = nftResponse.rating
        self.nftName = nftResponse.name

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
