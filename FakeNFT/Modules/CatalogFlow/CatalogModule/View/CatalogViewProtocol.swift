protocol CatalogViewProtocol: AnyObject {
    func update(with viewModels: [CatalogTableViewCellViewModel])
    func updateImage(with viewModel: CatalogTableViewCellViewModel, at index: Int)
    func displayAlert(model: AlertProtocol)
}

