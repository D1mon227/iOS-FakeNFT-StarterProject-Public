import UIKit

struct CatalogTableViewCellViewModel {
    let imageStringUrl: String
    let nftTitle: String
    
    init(nftResponse: NftResponse) {
        imageStringUrl = nftResponse.cover
        nftTitle = nftResponse.name + " (\(nftResponse.nfts.count))"
    }
}

final class CatalogTableViewCell: UITableViewCell {
    
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
    
    private func setupContent() {
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //nftCategoryCover
            
            //nftCategoryLabel
            
            ])
    }
    
    
    func configure(with viewModel: CatalogTableViewCellViewModel) {
        viewModel.imageStringUrl
        nftCategoryLabel.text = viewModel.nftTitle
        
    }
}

