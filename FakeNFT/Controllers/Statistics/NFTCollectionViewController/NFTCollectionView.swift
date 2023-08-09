import UIKit

protocol INFTCollectionView: AnyObject, UICollectionViewDelegate, UICollectionViewDataSource {
	func setDelegateDataSource(delegate: UICollectionViewDelegate & UICollectionViewDataSource)
	func updateUI(with data: [NFT])
	func fetchLikes(with data: Profile)
	func fetchOrders(with data: Order)
	var activityIndicator: UIActivityIndicatorView { get }
}

final class NFTCollectionView: UIView {
	var collectionNFT: [NFT] = []
	var profile: Profile?
	var order: Order?
	var presenter: NFTCollectionPresenter?
	
	enum Metrics {
		static let collectionItemSize = CGSize(width: 108, height: 192)
		static let spacing: CGFloat = 0
	}
	
	let nftCollectionView: UICollectionView = {
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
	
	let activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: .large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicator
	}()
	
	let emptyLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont.bodyBold
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "У Вас ещё нет NFT"
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
	func setDelegateDataSource(delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
		nftCollectionView.delegate = delegate
		nftCollectionView.dataSource = delegate
	}
	
	func updateUI(with data: [NFT]) {
		collectionNFT = data
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.nftCollectionView.reloadData()
			emptyLabel.isHidden = !collectionNFT.isEmpty
		}
	}
	
	func fetchLikes(with data: Profile) {
		profile = data
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.nftCollectionView.reloadData()
		}
	}
	
	func fetchOrders(with data: Order) {
		order = data
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.nftCollectionView.reloadData()
		}
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
