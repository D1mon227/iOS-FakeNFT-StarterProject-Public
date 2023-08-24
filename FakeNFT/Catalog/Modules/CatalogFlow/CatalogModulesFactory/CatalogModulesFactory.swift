
final class CatalogModulesFactory {
    static func makeCatalogModule() -> CatalogViewController {
        let networkManager = NetworkManager()
        let presenter = CatalogPresenter(networkManager: networkManager)
        let viewController = CatalogViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
    
    static func makeDetailedCollectionModule(response: NFTCollection) -> DetailedCollectionViewController {
        let networkManager = NetworkManager()
        let presenter = DetailedCollectionPresenter(networkManager: networkManager, response: response)
        let viewController = DetailedCollectionViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
