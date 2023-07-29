import UIKit

final class ProfileView {
    lazy var profileImage: UIImageView = {
        let element = UIImageView()
        element.image = Resourses.Images.Profile.profileImage
        element.layer.cornerRadius = 35
        element.layer.masksToBounds = true
        return element
    }()
    
    lazy var profileName: UILabel = {
        let element = UILabel()
        element.text = "Joaquin Phoenix"
        element.font = .headline3
        element.textColor = .blackDay
        return element
    }()
    
    lazy var profileDescription: UILabel = {
        let element = UILabel()
        element.text = "Дизайнер из Казани, люблю цифровое искусство\nи бейглы. В моей коллекции уже 100+ NFT,\nи еще больше — на моём сайте. Открыт\nк коллаборациям."
        element.font = .caption2
        element.numberOfLines = 0
        return element
    }()
    
    lazy var websiteButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Joaquin Phoenix.com", for: .normal)
        element.setTitleColor(.blueUniversal, for: .normal)
        element.titleLabel?.font = .caption1
        element.titleLabel?.numberOfLines = 0
        return element
    }()
    
    lazy var profileTableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        return element
    }()
}
