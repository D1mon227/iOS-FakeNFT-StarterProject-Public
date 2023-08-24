import Foundation

protocol ResetPasswordViewPresenterProtocol: AnyObject {
    var view: ResetPasswordViewControllerProtocol? { get set }
    func setupEmail(email: String?)
    func resetPassword()
}
