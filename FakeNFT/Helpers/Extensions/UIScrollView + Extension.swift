import UIKit

extension UIScrollView {
    func adjustScrollDirectionForLanguage() {
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        } else {
            transform = CGAffineTransform.identity
        }
    }
}
