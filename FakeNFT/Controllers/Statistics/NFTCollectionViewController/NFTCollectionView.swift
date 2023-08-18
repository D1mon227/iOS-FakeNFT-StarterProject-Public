import UIKit

protocol INFTCollectionView: AnyObject {
	func setDelegateDataSource()
	func updateUI(with data: [NFT])
	func showFavorites(with data: Likes)
	func showCart(with data: Order)
}

final class NFTCollectionView: UIView {
	var collectionNFT: [NFT] = []
	var likes: Likes?
	var order: Order?
	var presenter: INFTCollectionPresenter?
	
	enum Metrics {
		static let collectionItemSize = CGSize(width: 108, height: 192)
		static let spacing: CGFloat = 0
	}
	
	private let nftCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = Metrics.spacing
		layout.itemSize = Metrics.collectionItemSize
		layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 8, right: 16)
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.showsVerticalScrollIndicator = false
		cv.backgroundColor = UIColor.backgroundDay
		cv.register(NFTCollectionCell.self, forCellWithReuseIdentifier: NFTCollectionCell.identifier)
		return cv
	}()
	
	private let activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: .large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicator
	}()
	
	private let emptyLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont.bodyBold
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = LocalizableConstants.Profile.noNFT
		return label
	}()
	
	init() {
		super.init(frame: .zero)
		self.configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension NFTCollectionView: INFTCollectionView {
	func setDelegateDataSource() {
		nftCollectionView.delegate = self
		nftCollectionView.dataSource = self
	}
	
	func updateUI(with data: [NFT]) {
		collectionNFT = data
		self.nftCollectionView.reloadData()
		emptyLabel.isHidden = !collectionNFT.isEmpty
	}
	
	func showFavorites(with data: Likes) {
		likes = data
		self.nftCollectionView.reloadData()
	}
	
	func showCart(with data: Order) {
		order = data
		self.nftCollectionView.reloadData()
	}
}

private extension NFTCollectionView {
	func configureView() {
		self.backgroundColor = UIColor.backgroundDay
		self.addSubview(self.nftCollectionView)
		self.addSubview(self.activityIndicator)
		nftCollectionView.addSubview(self.emptyLabel)
		emptyLabel.isHidden = true
		
		NSLayoutConstraint.activate([
			nftCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			nftCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			nftCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			nftCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			
			emptyLabel.centerXAnchor.constraint(equalTo: nftCollectionView.centerXAnchor),
			emptyLabel.centerYAnchor.constraint(equalTo: nftCollectionView.centerYAnchor)
		])
	}
}
