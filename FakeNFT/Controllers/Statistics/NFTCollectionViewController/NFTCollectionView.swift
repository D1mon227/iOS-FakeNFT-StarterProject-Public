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

	private func doesNftHasLike(id: String) -> Bool {
		guard let likes = likes?.likes else { return false }
		return likes.contains(id)
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

extension NFTCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
	
	// MARK: - UITableViewDataSource
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionNFT.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionCell.identifier, for: indexPath) as? NFTCollectionCell else {
			return UICollectionViewCell()
		}
		let nft = collectionNFT[indexPath.row]
		let isLiked = likes?.likes.contains(nft.id ?? "")
		let isInCart = order?.nfts.contains(nft.id ?? "")
		cell.configure(with: nft, isLiked: isLiked ?? false, isInCart: isInCart ?? false, order: order)
		
		if let id = order?.id {
			cell.onCartButtonTapped = {
				self.presenter?.tapOnTheCell(for: nft.id ?? "", profile: id)
			}
			
			cell.onFavoriteButtonTapped = {
				self.presenter?.tapOnTheCell(for: nft.id ?? "")
			}
		}
		return cell
	}
	
	// MARK: - UITableViewDelegate
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedUser = collectionNFT[indexPath.row]
		let hasLike = doesNftHasLike(id: selectedUser.id ?? "")
		presenter?.tapOnTheCell(nft: selectedUser, like: hasLike)
	}
}
