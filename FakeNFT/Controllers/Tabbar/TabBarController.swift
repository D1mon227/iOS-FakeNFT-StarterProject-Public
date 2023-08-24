import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .backgroundDay
        setupTabBar()
    }
    
    private func setupTabBar() {

		let appCoordinator = AppCoordinator(tabBarController: self)
		let profile = ModuleFactory.makeProfileModule()
        let catalog = CatalogModulesFactory.makeCatalogModule()
        let statistics = ModuleFactory.makeStatisticModule(appCoordinator: appCoordinator)
        
        let profileNC = CustomNavigationController(rootViewController: profile)
        let catalogNC = CustomNavigationController(rootViewController: catalog)
        let cartNC = CustomNavigationController(rootViewController: CartViewController())
		let statisticsNC = CustomNavigationController(rootViewController: statistics)

        
        profileNC.tabBarItem = UITabBarItem(title: LocalizableConstants.TabBar.profile,
                                            image: Resourses.Images.TabBar.profileTabBar,
                                            selectedImage: nil)
        catalogNC.tabBarItem = UITabBarItem(title: LocalizableConstants.TabBar.catalog,
                                            image: Resourses.Images.TabBar.catalogTabBar,
                                            selectedImage: nil)
        cartNC.tabBarItem = UITabBarItem(title: LocalizableConstants.TabBar.cart,
                                            image: Resourses.Images.TabBar.cartTabBar,
                                            selectedImage: nil)
        statisticsNC.tabBarItem = UITabBarItem(title: LocalizableConstants.TabBar.statistics,
                                            image: Resourses.Images.TabBar.statisticsTabBar,
                                            selectedImage: nil)
        
        tabBar.unselectedItemTintColor = .blackDay

        self.viewControllers = [profileNC, catalogNC, cartNC, statisticsNC]
    }
}
