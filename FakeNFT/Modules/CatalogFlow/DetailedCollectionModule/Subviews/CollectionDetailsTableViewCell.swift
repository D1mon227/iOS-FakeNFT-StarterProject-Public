import UIKit
import Kingfisher

private class CollectionDetailsCell {
    
    // MARK: - Layout elements
    
//    let corners = UIRectCorner(arrayLiteral: [
//        UIRectCorner.bottomLeft,
//        UIRectCorner.bottomRight
//    ])
    
    private let nftCollectionCover: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nftCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
   
    private let nftCategoryDe: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        
        return label
    }()
    
    
    private var gradientLayer: CAGradientLayer?
    
    
    
}
