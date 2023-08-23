import Foundation

protocol NFTCardViewControllerProtocol: AnyObject {
    var presenter: NFTCardViewPresenterProtocol? { get set }
    func reloadTableView()
    func reloadCollectionView()
    func updateNFTCollectionName(name: String)
    func showCurrencyErrorAlert()
    func showNFTsErrorAlert()
    func showErrorAlert()
    func showLikeErrorAlert(id: String)
}
