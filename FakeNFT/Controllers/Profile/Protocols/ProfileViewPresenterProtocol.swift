import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var profile: Profile? { get set }
    func fetchProfile()
    func switchToAuthorInformation() -> WebViewController?
}
