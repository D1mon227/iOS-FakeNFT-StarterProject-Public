import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.show()
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
    
    static func setupProgressHUD() {
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.colorHUD = .backgroundDay
        ProgressHUD.colorAnimation = .blackDay
    }
}
