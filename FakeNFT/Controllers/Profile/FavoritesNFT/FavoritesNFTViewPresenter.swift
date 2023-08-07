import Foundation

final class FavoritesNFTViewPresenter: FavoritesNFTViewPresenterProtocol {
    weak var view: FavoritesNFTViewControllerProtocol?
    
    var favoritesNFTs: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadCollectionView()
            }
        }
    }
}
