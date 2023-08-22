import UIKit

protocol DetailedCollectionViewProtocol: AnyObject, LoadableProtocol {
    func present(_ vc: UIViewController)
    func updateDetailsCollectionModel(with viewModel: CollectionDetailsCollectionViewCellModel)
    func updateNftsModel(with viewModels: [NFTCollectionViewCellViewModel])
    func showNetworkError(model: NetworkErrorViewModel)
    func hideNetworkError()
}

