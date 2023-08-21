import Foundation

protocol ResetPasswordViewControllerProtocol: AnyObject {
    var presenter: ResetPasswordViewPresenterProtocol? { get set }
    func checkPasswordReset(successfulReset: Bool)
    func showNewEmailPlaceholder()
}
