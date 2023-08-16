import UIKit
import SnapKit

final class FavoritesNFTViewController: UIViewController, FavoritesNFTViewControllerProtocol {
    var presenter: FavoritesNFTViewPresenterProtocol?
    private var profilePresenter: ProfileViewPresenterProtocol?
    private let favoritesNFTView = FavoritesNFTView()
    private let analyticsService = AnalyticsService.shared
    
    init(profilePresenter: ProfileViewPresenterProtocol?, likes: [String]?) {
        super.init(nibName: nil, bundle: nil)
        self.profilePresenter = profilePresenter
        self.presenter = FavoritesNFTViewPresenter(profilePresenter: profilePresenter)
        self.presenter?.view = self
        self.presenter?.likes = likes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundDay
        analyticsService.report(event: .open, screen: .favoritesNFTsVC, item: nil)
        setupCollectionView()
        presenter?.fetchNFTs()
        setupTitle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: .close, screen: .favoritesNFTsVC, item: nil)
    }
    
    private func setupCollectionView() {
        favoritesNFTView.nftCollectionView.dataSource = self
        favoritesNFTView.nftCollectionView.delegate = self
        favoritesNFTView.nftCollectionView.register(FavoritesNFTCollectionViewCell.self, forCellWithReuseIdentifier: "FavoritesNFTCollectionViewCell")
    }
    
    func reloadViews() {
        setupTitle()
        presenter?.areFavoritesNFTsEmpty() ?? false ? addEmptyLabel() : addCollectionView()
    }
    
    private func addEmptyLabel() {
        favoritesNFTView.nftCollectionView.removeFromSuperview()
        view.addSubview(favoritesNFTView.emptyLabel)
        favoritesNFTView.emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func addCollectionView() {
        favoritesNFTView.emptyLabel.removeFromSuperview()
        view.addSubview(favoritesNFTView.nftCollectionView)
        favoritesNFTView.nftCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    private func setupTitle() {
        guard let presenter = presenter else { return }
        if presenter.areFavoritesNFTsEmpty() {
            self.title = nil
        } else {
            self.title = LocalizableConstants.Profile.nftFavorites
        }
    }
}

//MARK: UICollectionViewDataSource
extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.favoritesNFTs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesNFTCollectionViewCell", for: indexPath) as? FavoritesNFTCollectionViewCell,
              let nfts = presenter?.favoritesNFTs[indexPath.row] else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.configureCell(image: nfts.images?[0],
                           favoriteButtonColor: .redUniversal,
                           nftName: nfts.name,
                           rating: nfts.rating,
                           price: (presenter?.convert(price: nfts.price ?? 0.0) ?? "") + " ETH")
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 39) / 2, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

//MARK: FavoritesNFTCollectionViewCellDelegate
extension FavoritesNFTViewController: FavoritesNFTCollectionViewCellDelegate {
    func didTapLike(_ cell: FavoritesNFTCollectionViewCell) {
        guard let indexPath = favoritesNFTView.nftCollectionView.indexPath(for: cell),
              let presenter = presenter else { return }
        let nftID = presenter.favoritesNFTs[indexPath.row].id
        presenter.changeLike(nftID)
        analyticsService.report(event: .click, screen: .favoritesNFTsVC, item: .like)
        
        favoritesNFTView.nftCollectionView.performBatchUpdates {
            presenter.favoritesNFTs.remove(at: indexPath.row)
            favoritesNFTView.nftCollectionView.deleteItems(at: [indexPath])
        }
    }
}
