import UIKit

final class FavoritesNFTView {
    lazy var nftCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let element = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        element.backgroundColor = .backgroundDay
        return element
    }()
    
    lazy var emptyLabel: UILabel = {
        let element = UILabel()
        element.font = .bodyBold
        element.textColor = .blackDay
        element.text = LocalizableConstants.Profile.noFavoritesNFT
        return element
    }()
}
