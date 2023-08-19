import Foundation

protocol AuthViewControllerProtocol: AnyObject {
    var presenter: AuthViewPresenterProtocol? { get set }
    func checkAuthorization(successfulAuthorization: Bool)
    func checkLoginPasswordMistake(incorrect: Bool)
}
