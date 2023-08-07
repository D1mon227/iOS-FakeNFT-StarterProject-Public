protocol CatalogViewProtocol: AnyObject {
    func update(with viewModels: [CatalogTableViewCellViewModel])
    func displayAlert(model: AlertProtocol)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

