import UIKit

protocol AlertServiceProtocol: AnyObject {
    func showSortAlert(model: AlertSortModel, controller: UIViewController)
    func showErrorAlert(model: AlertErrorModel, controller: UIViewController)
}
