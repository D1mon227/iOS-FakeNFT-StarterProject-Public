
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
        let profileService = ProfileServiceCatalog()
        let cartService = CartService()
        let services = DetailedCollectionPresenter.Services(profileService: profileService,
                                                            nftService: nftService,
                                                            cartService: cartService)

        let presenter = DetailedCollectionPresenter(response: response,
                                                    services: services
        )
        let viewController = DetailedCollectionViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
