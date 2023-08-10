
final class CatalogModulesFactory {
    static func makeCatalogModule() -> CatalogViewController {
        let nftCatalogService = NftCatalogService()
        let presenter = CatalogPresenter(nftCatalogService: nftCatalogService)
        let viewController = CatalogViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
    
    static func makeDetailedCollectionModule(response: NftCollectionResponse) -> DetailedCollectionViewController {
        let nftService = NftService()
        let authorService = NFTAuthorService()
        let presenter = DetailedCollectionPresenter(response: response, authorService: authorService, nftService: nftService)
        let viewController = DetailedCollectionViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
