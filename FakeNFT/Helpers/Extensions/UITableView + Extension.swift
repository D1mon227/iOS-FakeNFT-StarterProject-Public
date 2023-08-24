import UIKit

public extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
}

public extension UITableViewHeaderFooterView {
    static var identifier: String {
        String(describing: self)
    }
}
