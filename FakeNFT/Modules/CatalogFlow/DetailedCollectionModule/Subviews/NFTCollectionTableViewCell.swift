
import UIKit

final class NFTCollectionTableViewCell: UITableViewCell {
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewLayout())
    
    
    

    
}

struct NFTCollectionCollectionViewCellModel {
    let nftIcon: String?
    let nftStarsCount: Int
    let nftNameLabel: String
    let price: Float
    
    init(nftResponse: NftResponse) {
        self.nftIcon = nftResponse.images.first
        self.nftNameLabel = nftResponse.name
        self.nftStarsCount = nftResponse.rating
        self.price = nftResponse.price
    }
}

final class NFTCollectionCollectionViewCell: UICollectionViewCell {
    //    private let nftIcon: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        imageView.layer.cornerRadius = 12
    //        imageView.layer.masksToBounds = true
    //        return imageView
    //    }()
    //
    //    private let nftStars: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    //
    //        return label
    //    }()
    //
    //    private let nftNameLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.font = UIFont.systemFont(ofSize: 10)
    //
    //        return label
    //    }()
    //
    //    private let nftPriceLabel: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.font = UIFont.systemFont(ofSize: 10)
    //
    //        return label
    //    }()
    //
    //    private let nftLikeButton: UIButton = {
    //        let button = UIButton()
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //
    //        return button
    //    }()
    //
    //    private let nftCartButton: UIButton = {
    //        let button = UIButton()
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //
    //        return button
    //    }()
}
