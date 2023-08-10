import UIKit
import Kingfisher

final class CollectionDetailsCell: UITableViewCell {
    
    // MARK: - Layout elements
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CollectionDetailsCell {
    
    func setupViews() {
        addSubviews()
        setupNftCollectionCover()
    }
    
    func setupNftCollectionCover() {
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.bottomLeft,
            UIRectCorner.bottomRight
        ])
        
//        Determine the size of the rounded corners
        let cornerRadii = CGSize(
            width: 12,
            height: 12
        )
        
        nftCollectionCover.applyCorners(cornerRadii: cornerRadii, corners: corners)
    }
    
    func addSubviews() {
        
    }
}
