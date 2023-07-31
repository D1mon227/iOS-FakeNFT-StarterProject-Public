import UIKit

final class TabBarController: UITabBarController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .backgroundDay
        setupTabBar()
    }
    
    private func setupTabBar() {
        let profileVC = CustomNavigationController(rootViewController: ProfileViewController())
        let catalogVC = CustomNavigationController(rootViewController: CatalogViewController(presenter: ))
        let cartVC = CustomNavigationController(rootViewController: CartViewController())
		let statisticsVC = CustomNavigationController(rootViewController: StatisticsViewController())

        
        profileVC.tabBarItem = UITabBarItem(title: LocalizableConstants.TabBar.profile,
                                            image: Resourses.Images.TabBar.profileTabBar,
                                            selectedImage: nil)
        catalogVC.tabBarItem = UITabBarItem(title: LocalizableConstants.TabBar.catalog,
                                            image: Resourses.Images.TabBar.catalogTabBar,
                                            selectedImage: nil)
        cartVC.tabBarItem = UITabBarItem(title: LocalizableConstants.TabBar.cart,
                                            image: Resourses.Images.TabBar.cartTabBar,
                                            selectedImage: nil)
        statisticsVC.tabBarItem = UITabBarItem(title: LocalizableConstants.TabBar.statistics,
                                            image: Resourses.Images.TabBar.statisticsTabBar,
                                            selectedImage: nil)
        
        tabBar.unselectedItemTintColor = .blackDay
        self.viewControllers = [profileVC, catalogVC, cartVC, statisticsVC]
    }
}
