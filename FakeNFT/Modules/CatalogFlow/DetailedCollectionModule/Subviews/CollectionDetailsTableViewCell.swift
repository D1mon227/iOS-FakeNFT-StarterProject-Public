import UIKit
import Kingfisher

protocol CollectionDetailsCellProtocol {
    func didTapOnLink(url: URL?)
}

extension CollectionDetailsCell {
    enum Layout {
        static let nftCollectionCoverHeight: CGFloat = 310
        static let nftCollectionNameLabelTopOffset: CGFloat = 8
        static let nftCollectionAuthorLabelTopOffset: CGFloat = 10
        static let nftCollectionDescriptionLabelTopOffset: CGFloat = 8
        static let nftCollectionDescriptionLabelBottomOffset: CGFloat = 24
        static let nftCollectionLabelLeadingOffset: CGFloat = 10
    }
}

final class CollectionDetailsCell: UICollectionViewCell {
    
    weak var delegate: DetailedCollectionViewController?
    
    // MARK: - Layout elements
    
    private let nftCollectionCover: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return imageView
    }()
    
    private let nftCollectionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    private let nftCollectionAuthorLabel: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    private let nftCollectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        return label
    }()
    
    private var gradientLayer: CAGradientLayer?
    private var viewModel: CollectionDetailsTableViewCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize,
                                                                          withHorizontalFittingPriority: .required,
                                                                          verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: CollectionDetailsTableViewCellModel) {
        self.viewModel = viewModel
        nftCollectionCover.kf.setImage(with: viewModel.imageStringUrl) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.gradientLayer?.removeFromSuperlayer()
            }
        }
        nftCollectionNameLabel.text = viewModel.collectionName
        nftCollectionDescriptionLabel.text = viewModel.collectionDescription
        
        addTappableString()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func addTappableString() {
        guard let viewModel,
              let website = viewModel.website else { return }
        let fullText = "Автор коллекции: \(String(describing: viewModel.authorName))"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let tappableRange = (fullText as NSString).range(of: viewModel.authorName)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: tappableRange)
        attributedString.addAttribute(.link, value: website, range: tappableRange)
        
        nftCollectionAuthorLabel.attributedText = attributedString
        nftCollectionAuthorLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(authorNameTapped))
        nftCollectionAuthorLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func authorNameTapped() {
        delegate?.didTapOnLink(url: viewModel?.website)
    }
}

// MARK: - Layout methods

private extension CollectionDetailsCell {
    
    func setupViews() {
        addSubviews()
        setupCollectionDetailsConstraints()
        showGradientAnimation()
    }
    
    func addSubviews() {
        contentView.addSubview(nftCollectionCover)
        contentView.addSubview(nftCollectionNameLabel)
        contentView.addSubview(nftCollectionAuthorLabel)
        contentView.addSubview(nftCollectionDescriptionLabel)
    }
    
    func setupCollectionDetailsConstraints() {
        NSLayoutConstraint.activate([
            //nftCollectionCover
            nftCollectionCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftCollectionCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftCollectionCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftCollectionCover.heightAnchor.constraint(equalToConstant: Layout.nftCollectionCoverHeight),
            //nftCollectionNameLabel
            nftCollectionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.nftCollectionLabelLeadingOffset),
            nftCollectionNameLabel.topAnchor.constraint(equalTo: nftCollectionCover.bottomAnchor, constant: Layout.nftCollectionNameLabelTopOffset),
            //nftCollectionAuthorLabel
            nftCollectionAuthorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.nftCollectionLabelLeadingOffset),
            nftCollectionAuthorLabel.topAnchor.constraint(equalTo: nftCollectionNameLabel.bottomAnchor, constant: Layout.nftCollectionAuthorLabelTopOffset),
            //nftCategoryDescriptionLabel
            nftCollectionDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.nftCollectionLabelLeadingOffset),
            nftCollectionDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.nftCollectionLabelLeadingOffset),
            nftCollectionDescriptionLabel.topAnchor.constraint(equalTo: nftCollectionAuthorLabel.bottomAnchor, constant: Layout.nftCollectionDescriptionLabelTopOffset),
            nftCollectionDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                constant: -Layout.nftCollectionDescriptionLabelBottomOffset)
        ])
    }
    
    private func showGradientAnimation() {
        guard let sublayers = nftCollectionCover.layer.sublayers else {
            addGradientSublayer()
            return
        }
        guard !sublayers.contains(where: {$0 is CAGradientLayer }) else {
            return
        }
        addGradientSublayer()
    }
    
    func addGradientSublayer() {
        gradientLayer = CAGradientLayer().createLoadingGradient(
            width: UIScreen.main.bounds.width,
            height: Layout.nftCollectionCoverHeight,
            radius: 12
        )
        guard let gradientLayer else { return }
        nftCollectionCover.layer.addSublayer(gradientLayer)
    }
    
}

