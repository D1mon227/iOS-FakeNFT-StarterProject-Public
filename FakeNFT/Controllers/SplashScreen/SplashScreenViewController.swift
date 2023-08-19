import UIKit
import SnapKit
import Firebase

final class SplashScreenViewController: UIViewController {
    private lazy var splashLogo: UIImageView = {
        let element = UIImageView()
        element.image = Resourses.Images.SplashScreen.logo
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthToken()
    }
    
    private func checkAuthToken() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            if user != nil {
                self.switchToTabBarController()
            } else {
                self.switchAuthViewController()
            }
        }
    }
    
    private func switchToTabBarController() {
        let tabbar = TabBarController()
        tabbar.modalPresentationStyle = .fullScreen
        present(tabbar, animated: true)
    }
    
    private func switchAuthViewController() {
        let authVC = CustomNavigationController(rootViewController: AuthViewController())
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(splashLogo)
        setupConstraints()
    }
    
    private func setupConstraints() {
        splashLogo.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(77.68)
            make.width.equalTo(75)
        }
    }
}
