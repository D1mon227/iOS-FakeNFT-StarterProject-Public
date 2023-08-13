import UIKit

protocol DetailedCollectionViewProtocol: AnyObject {
    func updateViewModel(with viewModels: [DetailedCollectionTableViewCellProtocol])
    func present(_ vc: UIViewController)
}

