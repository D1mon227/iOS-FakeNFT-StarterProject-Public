
final class CatalogModulesFactory {
    static func makeCatalogModule() -> CatalogViewController {
        let nftCatalogService = NftCatalogService()
        let downloadImageService = DownloadImageService()
        let presenter = CatalogPresenter(nftCatalogService: nftCatalogService,
                                         downloadImageService: downloadImageService)
        let viewController = CatalogViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
