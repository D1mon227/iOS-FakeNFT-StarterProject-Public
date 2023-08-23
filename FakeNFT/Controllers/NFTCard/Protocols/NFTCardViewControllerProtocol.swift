import Foundation

protocol NFTCardViewControllerProtocol: AnyObject {
    var presenter: NFTCardViewPresenterProtocol? { get set }
    func reloadTableView()
    func reloadCollectionView()
    func showCurrencyErrorAlert()
    func showNFTsErrorAlert()
    func showLikeErrorAlert(id: String)
}
