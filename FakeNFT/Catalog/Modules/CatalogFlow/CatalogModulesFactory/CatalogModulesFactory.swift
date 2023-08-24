
final class CatalogModulesFactory {
    static func makeCatalogModule() -> CatalogViewController {
        let nftCatalogService = NftCatalogService()
        let presenter = CatalogPresenter(nftCatalogService: nftCatalogService)
        let viewController = CatalogViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
    
    static func makeDetailedCollectionModule(response: NFTCollection) -> DetailedCollectionViewController {
//        let nftService = NftService()
        let networkManager = NetworkManager()
//        let profileService = ProfileServiceCatalog()
        let cartService = CartService()
        let services = DetailedCollectionPresenter.Services(networkManager: networkManager,
                                                            cartService: cartService)

        let presenter = DetailedCollectionPresenter(response: response,
                                                    services: services
        )
        let viewController = DetailedCollectionViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
