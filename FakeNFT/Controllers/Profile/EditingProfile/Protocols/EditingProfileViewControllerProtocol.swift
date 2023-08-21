import Foundation

protocol EditingProfileViewControllerProtocol: AnyObject {
    var presenter: EditingProfileViewPresenterProtocol? { get set }
    func reloadTableView()
    func showErrorAlert()
}
