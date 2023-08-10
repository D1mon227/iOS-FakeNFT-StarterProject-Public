import UIKit
import Kingfisher

extension CollectionDetailsCell {
    enum Layout {
        static let nftCollectionCoverHeight: CGFloat = 179
    }
}

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
    
    func configure(with viewModel: CollectionDetailsTableViewCellModel) {
//        nftCollectionCover.kf.setImage(with: <#T##Source?#>)
        nftCategoryLabel.text = viewModel.collectionName
        nftCategoryDe.text = viewModel.collectionDescription
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
    
    func setupCollectionDetailsConstrains() {
        NSLayoutConstraint.activate([
            //nftCollectionCover
            nftCollectionCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCollectionCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCollectionCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftCollectionCover.heightAnchor.constraint(equalToConstant: Layout.nftCollectionCoverHeight),
            //nftCollectionNameLabel
            
            //nftCollectionAuthorLabel
            
            //nftCategoryDescriptionLabel
            
        ])
        
    }
}
