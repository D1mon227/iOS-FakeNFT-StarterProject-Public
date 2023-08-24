import UIKit

extension DetailedCollectionViewController {
    enum Layout {
        static let littleCellSize = CGSize(width: 108, height: 192)
        static let bigCellHeight: CGFloat = 500
        static let spacingBetweenCells: CGFloat = 8
    }
}

final class DetailedCollectionViewController: UIViewController {
    
    private let presenter: DetailedCollectionPresenterProtocol
    
    private let collectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = Layout.spacingBetweenCells
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.width
        
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: collectionViewFlowLayout)
        view.isScrollEnabled = true
        view.backgroundColor = .backgroundDay
        return view
    }()
    
    private var nftModels: [NFTCollectionViewCellViewModel] = []
    private var detailsCollectionModel: CollectionDetailsCollectionViewCellModel?
    
    init(presenter: DetailedCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
}

extension DetailedCollectionViewController: DetailedCollectionViewProtocol {
    func showLoadingIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updateDetailsCollectionModel(with viewModel: CollectionDetailsCollectionViewCellModel) {
        self.detailsCollectionModel = viewModel
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func updateNftsModel(with viewModels: [NFTCollectionViewCellViewModel]) {
        self.nftModels = viewModels
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func present(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showNetworkError(model: NetworkErrorViewModel) {
        hideLoadingIndicator()
        addNetworkErrorView(model: model)
    }
    
    func hideNetworkError() {
        removeNetworkErrorView()
    }
    
}

private extension DetailedCollectionViewController {
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupCollectionView() {
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CollectionDetailsCell.self,
                                forCellWithReuseIdentifier: CollectionDetailsCell.identifier)
        collectionView.register(NFTCollectionViewCell.self,
                                forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
    }
}

extension DetailedCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard detailsCollectionModel != nil else { return 0 }
        return section == 0 ? 1 : nftModels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionDetailsCell.identifier, for: indexPath) as? CollectionDetailsCell else {
                return UICollectionViewCell()
            }
            
            guard let detailsCollectionModel else { return cell }
            
            cell.configure(with: detailsCollectionModel)
            cell.delegate = self
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier,
                                                                for: indexPath) as? NFTCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = nftModels[indexPath.row]
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let screenWidth = UIScreen.main.bounds.width
            return CGSize(width: screenWidth, height: Layout.bigCellHeight)
        } else {
            return CGSize(width: Layout.littleCellSize.width, height: Layout.littleCellSize.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 { return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }
        let sectionInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NFTCollectionViewCell else {
            return
        }
        
        guard let id = cell.viewModel?.nftId else { return }
        presenter.didChooseNft(with: id)
    }
    
}

extension DetailedCollectionViewController: CollectionDetailsCellProtocol {
    func didTapOnLink(url: String?) {
        presenter.didTapOnLink(url: url)
    }
}

extension DetailedCollectionViewController: NFTCollectionViewCellDelegate {
    func didTapNFTLikeButton(id: String) {
        presenter.didTapLikeButton(id: id)
    }
    
    func didTapNFTCartButton(id: String) {
        presenter.didTapCartButton(id: id)
    }
    
}


