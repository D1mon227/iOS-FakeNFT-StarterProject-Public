import UIKit

protocol DetailedCollectionViewProtocol: AnyObject, LoadableProtocol {
    func present(_ vc: UIViewController)
    func updateDetailsCollectionModel(with viewModel: CollectionDetailsTableViewCellModel)
    func updateNftsModel(with viewModels: [NFTCollectionViewCellViewModel])
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

