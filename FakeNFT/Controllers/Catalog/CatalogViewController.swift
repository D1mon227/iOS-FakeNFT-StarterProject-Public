import UIKit

final class CatalogViewController: UIViewController {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .backgroundDay
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
}
