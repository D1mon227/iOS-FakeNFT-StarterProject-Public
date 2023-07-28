import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let profileVC = ProfileViewController()
        let catalogVC = CatalogViewController()
        let cartVC = CartViewController()
        let statisticsVC = StatisticsViewController()
        
        profileVC.tabBarItem = UITabBarItem(title: "Профиль",
                                            image: Resourses.Images.TabBar.profileTabBar,
                                            selectedImage: nil)
        catalogVC.tabBarItem = UITabBarItem(title: "Каталог",
                                            image: Resourses.Images.TabBar.catalogTabBar,
                                            selectedImage: nil)
        cartVC.tabBarItem = UITabBarItem(title: "Корзина",
                                            image: Resourses.Images.TabBar.cartTabBar,
                                            selectedImage: nil)
        statisticsVC.tabBarItem = UITabBarItem(title: "Статистика",
                                            image: Resourses.Images.TabBar.statisticsTabBar,
                                            selectedImage: nil)
        
        tabBar.unselectedItemTintColor = .black
        self.viewControllers = [profileVC, catalogVC, cartVC, statisticsVC]
    }
}
