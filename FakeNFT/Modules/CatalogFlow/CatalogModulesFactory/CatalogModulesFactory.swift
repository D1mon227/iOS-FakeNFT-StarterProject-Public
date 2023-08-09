
final class CatalogModulesFactory {
    static func makeCatalogModule() -> CatalogViewController {
        let nftCatalogService = NftCatalogService()
        let presenter = CatalogPresenter(nftCatalogService: nftCatalogService)
        let viewController = CatalogViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
    
    static func makeDetailedCollectionModule(response: NftCollectionResponse) -> DetailedCollectionViewController {
//        let nftCatalogService = NftCatalogService()
        let presenter = DetailedCollectionPresenter(response: response)
        let viewController = DetailedCollectionViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
