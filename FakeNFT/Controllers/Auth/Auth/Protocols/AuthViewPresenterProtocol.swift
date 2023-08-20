import Foundation

protocol AuthViewPresenterProtocol: AnyObject {
    var view: AuthViewControllerProtocol? { get set }
    func authorizeUser()
    func setupEmail(email: String?)
    func setupPassword(password: String?)
}
