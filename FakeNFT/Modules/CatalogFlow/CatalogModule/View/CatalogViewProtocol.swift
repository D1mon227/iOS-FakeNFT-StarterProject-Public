import UIKit

protocol CatalogViewProtocol: AnyObject {
    func update(with viewModels: [CatalogTableViewCellViewModel])
    func push(_ viewController: UIViewController)
    func displayAlert(model: AlertProtocol)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

