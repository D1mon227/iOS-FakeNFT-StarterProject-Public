import UIKit

final class ProfileView {
    lazy var profileImage: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 35
        element.layer.masksToBounds = true
        return element
    }()
    
    lazy var profileName: UILabel = {
        let element = UILabel()
        element.font = .headline3
        element.textColor = .blackDay
        element.numberOfLines = 0
        return element
    }()
    
    lazy var profileDescription: UILabel = {
        let element = UILabel()
        element.font = .caption2
        element.numberOfLines = 0
        return element
    }()
    
    lazy var websiteButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitleColor(.blueUniversal, for: .normal)
        element.titleLabel?.font = .caption1
        element.titleLabel?.numberOfLines = 0
        return element
    }()
    
    lazy var profileTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.backgroundColor = .backgroundDay
        return element
    }()
}
