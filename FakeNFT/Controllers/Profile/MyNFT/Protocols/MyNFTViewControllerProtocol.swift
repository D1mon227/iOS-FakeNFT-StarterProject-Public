import Foundation

protocol MyNFTViewControllerProtocol: AnyObject {
    var presenter: MyNFTViewPresenterProtocol? { get set }
    func reloadViews()
    func showNFTsErrorAlert()
    func showUsersErrorAlert()
    func showLikeErrorAlert(id: String)
}
