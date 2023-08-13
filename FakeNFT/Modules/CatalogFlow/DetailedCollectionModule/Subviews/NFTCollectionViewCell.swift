import UIKit
import Kingfisher

protocol NFTCollectionViewCellDelegateProtocol: AnyObject {
    func didTapNFTLikeButton(id: String)
    func didTapNFTCartButton(id: String)
}

extension NFTCollectionViewCell {
    enum Layout {
        static let nftIconCoverHeight: CGFloat = 108
        static let nftIconCoverWidth: CGFloat = 108
        static let nftStarsCountTopOffset: CGFloat = 4
        static let nftNameLabelTopOffset: CGFloat = 8
        static let nftPriceLabelTopOffset: CGFloat = 8
        static let nftPriceLabelBottomOffset: CGFloat = 20
        static let nftStarsCountHeight: CGFloat = 12
        static let nftStarsCountWidth: CGFloat = 68
    }
}

final class NFTCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Layout elements
    
    private let nftIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let nftPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()
    
    private let nftLikeButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 40.0, height: 40.0)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private let nftCartButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 40.0, height: 40.0)
        button.translatesAutoresizingMaskIntoConstraints = false
       
        return button
    }()
    
    private var starRatingView: StarRatingView = StarRatingView(rating: 0)
    
    // MARK: - Properties
    
    private var gradientLayer: CAGradientLayer?
    private(set) var viewModel: NFTCollectionViewCellViewModel?
    weak var delegate: NFTCollectionViewCellDelegateProtocol?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
        setupView()
        setupNFTCollectionViewConstrains()
        showGradientAnimation()
        contentView.backgroundColor = .backgroundDay
        backgroundColor = .backgroundDay
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with viewModel: NFTCollectionViewCellViewModel) {
        self.viewModel = viewModel
        
        nftIcon.kf.setImage(with: viewModel.nftIcon) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.gradientLayer?.removeFromSuperlayer()
            }
        }
        
        starRatingView.setStarsRatingImage(rating: viewModel.nftStarsCount)
        
        nftNameLabel.text = viewModel.nftName
        nftPriceLabel.text = "\(viewModel.nftPrice) ETH"
        
        setIsLiked(viewModel.isFavorite)
        setIsCartAdded(viewModel.isCartAdded)
       
    }
    
    private func setIsLiked(_ state: Bool) {
        let likeImage = state ? UIImage(named: "active") : UIImage(named: "noActive")
        nftLikeButton.setImage(likeImage, for: .normal)
    }
    
    private func setIsCartAdded(_ state: Bool) {
        let cartImage = state ? UIImage(named: "cart.fill") : UIImage(named: "cart")
        nftCartButton.setImage(cartImage, for: .normal)
    }
    
    @objc
    private func likeButtonClicked() {
        guard let viewModel else { return }
        delegate?.didTapNFTLikeButton(id: viewModel.nftId)
    }
    
    @objc
    private func cartButtonClicked() {
        guard let viewModel else { return }
        delegate?.didTapNFTCartButton(id: viewModel.nftId)
    }
    
}

extension NFTCollectionViewCell {
    
    // MARK: - Layout methods
    
    func setupView() {
        contentView.addSubview(nftIcon)
        contentView.addSubview(nftNameLabel)
        contentView.addSubview(nftPriceLabel)
        contentView.addSubview(nftLikeButton)
        contentView.addSubview(nftCartButton)
        contentView.addSubview(starRatingView)
    }
    
    func setupNFTCollectionViewConstrains() {
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //nftIcon
            nftIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftIcon.heightAnchor.constraint(equalToConstant: Layout.nftIconCoverHeight),
            nftIcon.widthAnchor.constraint(equalToConstant: Layout.nftIconCoverWidth),
            
            //nftStarsCount
            starRatingView.topAnchor.constraint(equalTo: nftIcon.bottomAnchor,constant: Layout.nftStarsCountTopOffset),
            starRatingView.leadingAnchor.constraint(equalTo: nftIcon.leadingAnchor),
            starRatingView.heightAnchor.constraint(equalToConstant: Layout.nftStarsCountHeight),
            starRatingView.widthAnchor.constraint(equalToConstant: Layout.nftStarsCountWidth),
            
            //nftNameLabel
            nftNameLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor,
                                              constant: Layout.nftNameLabelTopOffset),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftIcon.leadingAnchor),
            
            //nftPriceLabel
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor,
                                               constant: Layout.nftPriceLabelTopOffset),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftIcon.leadingAnchor),
            // здесь нужно указать константу
            nftPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.nftPriceLabelBottomOffset),
            nftPriceLabel.heightAnchor.constraint(equalToConstant: 12),
            
            //nftLikeButton
            nftLikeButton.topAnchor.constraint(equalTo: nftIcon.topAnchor),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftIcon.trailingAnchor),
            
            //nftCartButton
            nftCartButton.topAnchor.constraint(equalTo: starRatingView.bottomAnchor,
                                               constant: Layout.nftNameLabelTopOffset),
            nftCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func showGradientAnimation() {
        guard let sublayers = nftIcon.layer.sublayers else {
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
            width: UIScreen.main.bounds.width - 32,
            height: Layout.nftIconCoverHeight,
            radius: 12
        )
        guard let gradientLayer else { return }
        nftIcon.layer.addSublayer(gradientLayer)
    }
    
    func setupButtons() {
        nftCartButton.addTarget(self, action: #selector(cartButtonClicked), for: .touchUpInside)
        nftLikeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
}
