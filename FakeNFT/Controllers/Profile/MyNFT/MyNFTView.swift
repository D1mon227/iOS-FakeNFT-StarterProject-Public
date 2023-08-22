import UIKit

final class MyNFTView {
    lazy var myNFTTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.backgroundColor = .backgroundDay
        return element
    }()
    
    lazy var emptyLabel: UILabel = {
        let element = UILabel()
        element.font = .bodyBold
        element.textColor = .blackDay
        element.text = LocalizableConstants.Profile.noNFT
        return element
    }()
}
