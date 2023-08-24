import Foundation

protocol NFTCardViewControllerProtocol: AnyObject {
    var presenter: NFTCardViewPresenterProtocol? { get set }
    func reloadTableView()
    func reloadCollectionView()
    func updateNFTCollectionName(name: String)
    func showCurrencyErrorAlert()
    func showNFTsErrorAlert()
    func showProfileErrorAlert()
    func showLikeErrorAlert(id: String)
    func showCartErrorAlert(id: String)
    func showNftCollectionErrorAlert()
    func showCartErrorAlert()
}
