import UIKit

final class FavoritesNFTView {
    lazy var nftCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let element = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        element.backgroundColor = .backgroundDay
        return element
    }()
}
