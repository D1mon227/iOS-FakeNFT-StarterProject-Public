import UIKit

final class MyNFTView {
    lazy var myNFTTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.backgroundColor = .backgroundDay
        return element
    }()
}
