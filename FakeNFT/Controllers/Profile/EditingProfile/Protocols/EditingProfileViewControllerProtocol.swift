import Foundation

protocol EditingProfileViewControllerProtocol: AnyObject {
    var presenter: EditingProfileViewPresenterProtocol? { get set }
    var newProfile: NewProfile? { get set }
    func reloadTableView()
}
