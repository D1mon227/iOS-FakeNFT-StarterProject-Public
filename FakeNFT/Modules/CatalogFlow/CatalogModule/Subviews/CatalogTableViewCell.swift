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
    
    // MARK: - Layout elements
    
    private let nftCategoryCover: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nftCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Properties
    
    var identifier = "CatalogTableViewCell"
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with viewModel: CatalogTableViewCellViewModel) {
        nftCategoryCover.image = UIImage(named: "\(viewModel.imageStringUrl)")
        nftCategoryLabel.text = viewModel.nftTitle
        
    }
    
}

// MARK: - Layout methods

private extension CatalogTableViewCell {
    func setupContent() {
        selectionStyle = .none
        contentView.addSubview(nftCategoryCover)
        contentView.addSubview(nftCategoryLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // nftCategoryCover
            nftCategoryCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCategoryCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCategoryCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftCategoryCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // nftCategoryLabel
            nftCategoryLabel.topAnchor.constraint(equalTo: nftCategoryCover.bottomAnchor),
            nftCategoryLabel.trailingAnchor.constraint(equalTo: nftCategoryCover.trailingAnchor)
        ])
    }
}
