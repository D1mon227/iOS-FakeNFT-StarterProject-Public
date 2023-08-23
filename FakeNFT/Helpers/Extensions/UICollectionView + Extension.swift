import UIKit

public extension UICollectionViewCell {
    static var identifier: String {
        String(describing: self)
    }
}
