import Foundation

protocol FavoritesNFTViewControllerProtocol: AnyObject {
    var presenter: FavoritesNFTViewPresenterProtocol? { get set }
    func reloadCollectionView()
}
