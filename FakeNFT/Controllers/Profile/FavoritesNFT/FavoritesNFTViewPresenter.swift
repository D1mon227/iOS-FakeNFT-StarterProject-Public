import Foundation

final class FavoritesNFTViewPresenter: FavoritesNFTViewPresenterProtocol {
    weak var view: FavoritesNFTViewControllerProtocol?
    
    var nfts: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadCollectionView()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
