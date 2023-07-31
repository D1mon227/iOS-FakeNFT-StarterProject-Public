import UIKit

struct CatalogTableViewCellViewModel {
    let imageStringUrls: [String]
    let nftName: String
    let nftCount: String
    
    private let nftCategoryCover: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "")
        return imageView
    }()
    
    private let nftCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
//    init(nftCodable: NftCodable) {
//        imageStringUrls = []
//        nftName = nftCodable.name
//        nftCount = nftCodable.count
//    }
    
    // MARK: - Properties
    
    static let identifier = "catalogCell"
    
    private func setupContent() {
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //nftCategoryCover
            
            //nftCategoryLabel
            
            ])
    }
    
    
}

final class CatalogTableViewCell: UITableViewCell {
    
    
    func configure(with viewModel: CatalogTableViewCellViewModel) {

    }
}

