import Foundation

protocol FavoritesNFTViewControllerProtocol: AnyObject {
    var presenter: FavoritesNFTViewPresenterProtocol? { get set }
    func reloadViews()
    func showNFTsErrorAlert()
    func showErrorAlert()
    func showLikeErrorAlert(id: String)
}
