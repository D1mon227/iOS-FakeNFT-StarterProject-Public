import Foundation

protocol FavoritesNFTViewControllerProtocol: AnyObject {
    var presenter: FavoritesNFTViewPresenterProtocol? { get set }
    func reloadViews()
    func showNFTsErrorAlert()
    func showLikeErrorAlert(id: String)
}
