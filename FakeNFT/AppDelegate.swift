import UIKit
import Firebase

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let analyticsService = AnalyticsService.shared
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        analyticsService.activate()
        UIBlockingProgressHUD.setupProgressHUD()
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
