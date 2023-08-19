import Foundation

protocol AuthViewControllerProtocol: AnyObject {
    var presenter: AuthViewPresenterProtocol? { get set }
}
