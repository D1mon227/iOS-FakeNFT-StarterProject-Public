import UIKit

final class EditingProfileView {
    lazy var closeButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(Resourses.Images.Button.closeButton, for: .normal)
        element.tintColor = .blackDay
        return element
    }()
    
    lazy var profileImage: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 35
        element.layer.masksToBounds = true
        return element
    }()
    
    lazy var frontImage: UIImageView = {
        let element = UIImageView()
        element.backgroundColor = .black.withAlphaComponent(0.6)
        element.layer.cornerRadius = 35
        return element
    }()
    
    lazy var editingPhotoButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(LocalizableConstants.Profile.changePhoto, for: .normal)
        element.titleLabel?.font = .caption3
        element.setTitleColor(.white, for: .normal)
        element.titleLabel?.numberOfLines = 0
        element.titleLabel?.textAlignment = .center
        element.layer.cornerRadius = 35
        return element
    }()
    
    lazy var editingTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.isScrollEnabled = false
        element.backgroundColor = .backgroundDay
        return element
    }()
}
