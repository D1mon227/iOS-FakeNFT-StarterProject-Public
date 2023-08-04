import UIKit

struct CatalogTableViewCellViewModel {
    let id: String
    let imageStringUrl: String
    let nftTitle: String
    var imageData: Data?
    
    init(nftResponse: NftResponse) {
        self.id = nftResponse.id
        self.imageStringUrl = nftResponse.cover
        self.nftTitle = nftResponse.name + " (\(nftResponse.nfts.count))"
    }
}

final class CatalogTableViewCell: UITableViewCell {
    
    // MARK: - Layout elements
    
    private let nftCategoryCover: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nftCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private let nftCategoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) var viewModel: CatalogTableViewCellViewModel?
    
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
        self.viewModel = viewModel
        if let data = viewModel.imageData {
            nftCategoryCover.image = UIImage(data: data)
        }
        nftCategoryLabel.text = viewModel.nftTitle
        layoutIfNeeded()
    }
    
}

// MARK: - Layout methods

private extension CatalogTableViewCell {
    func setupContent() {
        selectionStyle = .none
        contentView.addSubview(nftCategoryView)
        nftCategoryView.addSubview(nftCategoryCover)
        nftCategoryView.addSubview(nftCategoryLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            //nftCategoryView
            nftCategoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCategoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCategoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftCategoryView.heightAnchor.constraint(equalToConstant: 179),
            // nftCategoryCover
            nftCategoryCover.leadingAnchor.constraint(equalTo: nftCategoryView.leadingAnchor),
            nftCategoryCover.topAnchor.constraint(equalTo: nftCategoryView.topAnchor),
            nftCategoryCover.trailingAnchor.constraint(equalTo: nftCategoryView.trailingAnchor),
            nftCategoryCover.bottomAnchor.constraint(equalTo: nftCategoryLabel.topAnchor),
            // nftCategoryLabel
            nftCategoryLabel.leadingAnchor.constraint(equalTo: nftCategoryCover.leadingAnchor),
            nftCategoryLabel.bottomAnchor.constraint(equalTo: nftCategoryView.bottomAnchor),
        ])
    }
}

