import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
    }
    
    private func setupTabBar() {
        let profileVC = ProfileViewController()
        let catalogVC = CatalogViewController()
        let cartVC = CartViewController()
        let statisticsVC = StatisticsViewController()
        
        profileVC.tabBarItem = UITabBarItem(title: "Профиль",
                                            image: UIImage(systemName: "person.crop.circle.fill"),
                                            selectedImage: nil)
        catalogVC.tabBarItem = UITabBarItem(title: "Каталог",
                                            image: UIImage(systemName: "rectangle.stack.fill"),
                                            selectedImage: nil)
        cartVC.tabBarItem = UITabBarItem(title: "Корзина",
                                            image: UIImage(systemName: "bag.fill"),
                                            selectedImage: nil)
        statisticsVC.tabBarItem = UITabBarItem(title: "Статистика",
                                            image: UIImage(systemName: "flag.2.crossed.fill"),
                                            selectedImage: nil)
        
        tabBar.unselectedItemTintColor = .black
        self.viewControllers = [profileVC, catalogVC, cartVC, statisticsVC]
    }
}
