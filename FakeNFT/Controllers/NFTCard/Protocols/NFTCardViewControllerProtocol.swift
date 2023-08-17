import Foundation

protocol NFTCardViewControllerProtocol: AnyObject {
    var presenter: NFTCardViewPresenterProtocol? { get set }
    func reloadTableView()
    func reloadCollectionView()
}
