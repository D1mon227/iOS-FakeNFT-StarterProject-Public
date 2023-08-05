import UIKit
import Kingfisher

extension CatalogTableViewCell {
    enum Layout {
        static let nftCategoryLabelTopOffset: CGFloat = 4
        static let nftCategoryLabelBottomOffset: CGFloat = 43
        static let nftCategoryCoverHeight: CGFloat = 179
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

        nftCategoryCover.kf.setImage(with: viewModel.imageStringUrl)
        if let data = viewModel.imageData {
            nftCategoryCover.image = UIImage(data: data)
        }
        nftCategoryLabel.text = viewModel.nftTitle
    }
}

// MARK: - Layout methods

private extension CatalogTableViewCell {
    func setupContent() {
        selectionStyle = .none
        contentView.backgroundColor = .backgroundDay
        contentView.addSubview(nftCategoryCover)
        contentView.addSubview(nftCategoryLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // nftCategoryCover
            nftCategoryCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCategoryCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCategoryCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftCategoryCover.heightAnchor.constraint(equalToConstant: Layout.nftCategoryCoverHeight),
            
            // nftCategoryLabel
            nftCategoryLabel.topAnchor.constraint(equalTo: nftCategoryCover.bottomAnchor,
                                                  constant: Layout.nftCategoryLabelTopOffset),
            nftCategoryLabel.leadingAnchor.constraint(equalTo: nftCategoryCover.leadingAnchor),
            nftCategoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                     constant: -Layout.nftCategoryLabelBottomOffset)
        ])
    }
}

