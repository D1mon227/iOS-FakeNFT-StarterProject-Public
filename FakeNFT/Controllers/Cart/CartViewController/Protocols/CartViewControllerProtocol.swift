import Foundation

protocol CartViewControllerProtocol: AnyObject {
    var presenter: CartPresenterProtocol? { get set }
    func reloadViews()
}
