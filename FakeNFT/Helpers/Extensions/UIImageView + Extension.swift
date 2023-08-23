import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with url: URL?) {
        kf.indicatorType = .activity
        kf.setImage(with: url, options: [.transition(.fade(0.5))])
    }
}
