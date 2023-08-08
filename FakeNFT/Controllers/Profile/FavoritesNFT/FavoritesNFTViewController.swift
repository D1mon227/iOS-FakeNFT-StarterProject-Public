import UIKit
import SnapKit

final class FavoritesNFTViewController: UIViewController, FavoritesNFTViewControllerProtocol {
    var presenter: FavoritesNFTViewPresenterProtocol?
    private var profilePresenter: ProfileViewPresenterProtocol?
    private let favoritesNFTView = FavoritesNFTView()
    
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
        setupViews()
        setupCollectionView()
        presenter?.getFavoritesNFTs()
    }
    
    private func setupCollectionView() {
        favoritesNFTView.nftCollectionView.dataSource = self
        favoritesNFTView.nftCollectionView.delegate = self
        favoritesNFTView.nftCollectionView.register(FavoritesNFTCollectionViewCell.self, forCellWithReuseIdentifier: "FavoritesNFTCollectionViewCell")
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.favoritesNFTView.nftCollectionView.reloadData()
        }
    }
}

extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.favoritesNFTs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesNFTCollectionViewCell", for: indexPath) as? FavoritesNFTCollectionViewCell,
              let nfts = presenter?.favoritesNFTs?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.configureCell(image: nfts.images[0],
                           favoriteButtonColor: .redUniversal,
                           nftName: nfts.name,
                           rating: nfts.rating,
                           price: String(nfts.price) + " ETH")
        
        return cell
    }
}

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

extension FavoritesNFTViewController: FavoritesNFTCollectionViewCellDelegate {
    func didTapLike(_ cell: FavoritesNFTCollectionViewCell) {
        guard let indexPath = favoritesNFTView.nftCollectionView.indexPath(for: cell),
              let presenter = presenter else { return }
        let nftID = presenter.favoritesNFTs?[indexPath.row].id ?? ""
        presenter.changeLike(nftID)
    }
}

extension FavoritesNFTViewController {
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(favoritesNFTView.nftCollectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        favoritesNFTView.nftCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
}
