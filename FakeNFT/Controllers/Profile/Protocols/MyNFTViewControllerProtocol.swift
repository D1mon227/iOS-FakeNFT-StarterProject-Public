import Foundation

protocol MyNFTViewControllerProtocol: AnyObject {
    var presenter: MyNFTViewPresenterProtocol? { get set }
    func reloadTableView()
}
