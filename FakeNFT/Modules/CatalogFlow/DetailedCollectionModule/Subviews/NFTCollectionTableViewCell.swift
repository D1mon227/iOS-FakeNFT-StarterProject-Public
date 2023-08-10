
import UIKit

final class NFTCollectionTableViewCell: UITableViewCell {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundDay
        view.register(
            NFTCollectionViewCell.self,
            forCellWithReuseIdentifier: NFTCollectionViewCell.identifier
        )
        return view
    }()
    
    
    
    func setupCollectionView() {
        //collectionView.addSubview(<#T##view: UIView##UIView#>)
    }

    func setupCollectionViewConstrains() {
        NSLayoutConstraint.activate([
        //
        ])
    }
    
}

struct NFTCollectionViewCellModel {
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
