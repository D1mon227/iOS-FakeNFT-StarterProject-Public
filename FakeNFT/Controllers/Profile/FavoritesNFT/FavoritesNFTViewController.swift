import UIKit
import SnapKit

final class FavoritesNFTViewController: UIViewController, FavoritesNFTViewControllerProtocol {
    private let favoritesNFTView = FavoritesNFTView()
    var presenter: FavoritesNFTViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
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
        presenter?.nfts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesNFTCollectionViewCell", for: indexPath) as? FavoritesNFTCollectionViewCell,
              let nfts = presenter?.nfts?[indexPath.row] else { return UICollectionViewCell() }
        
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
