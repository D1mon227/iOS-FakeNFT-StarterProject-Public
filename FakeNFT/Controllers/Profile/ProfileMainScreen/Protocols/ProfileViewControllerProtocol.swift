import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile?)
    func showErrorAlert()
}
