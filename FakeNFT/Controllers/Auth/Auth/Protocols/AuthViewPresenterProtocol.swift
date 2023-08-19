import Foundation

protocol AuthViewPresenterProtocol: AnyObject {
    var view: AuthViewControllerProtocol? { get set }
    func authorizeUser()
    func setupEmailAndPassword(email: String?, password: String?)
}
