import UIKit

final class AuthView {
    lazy var entryLabel: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.font = .headline1
        element.textAlignment = .left
        element.text = LocalizableConstants.Auth.entryTitle
        return element
    }()
    
    lazy var emailTextField: UITextField = {
        let element = UITextField()
        element.placeholder = LocalizableConstants.Auth.emailPlaceholder
        element.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: element.frame.height))
        element.font = .bodyRegular
        element.textColor = .blackDay
        element.backgroundColor = .lightGreyDay
        element.autocapitalizationType = .none
        element.leftViewMode = .always
        element.clearButtonMode = .whileEditing
        element.layer.cornerRadius = 12
        return element
    }()
    
    lazy var passwordTextField: UITextField = {
        let element = UITextField()
        element.placeholder = LocalizableConstants.Auth.passwordPlaceholder
        element.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: element.frame.height))
        element.textColor = .blackDay
        element.backgroundColor = .lightGreyDay
        element.isSecureTextEntry = true
        element.autocapitalizationType = .none
        element.leftViewMode = .always
        element.clearButtonMode = .whileEditing
        element.layer.cornerRadius = 12
        return element
    }()
    
    lazy var enterButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(LocalizableConstants.Auth.enterButton, for: .normal)
        element.backgroundColor = .blackDay
        element.setTitleColor(.backgroundDay, for: .normal)
        element.titleLabel?.font = .bodyBold
        element.layer.cornerRadius = 16
        return element
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(LocalizableConstants.Auth.forgotPassword, for: .normal)
        element.setTitleColor(.blackDay, for: .normal)
        element.titleLabel?.font = .caption2
        element.titleLabel?.textAlignment = .center
        return element
    }()
    
    lazy var demoButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(LocalizableConstants.Auth.demo, for: .normal)
        element.setTitleColor(.blueUniversal, for: .normal)
        element.titleLabel?.font = .bodyBold
        element.titleLabel?.textAlignment = .center
        return element
    }()
    
    lazy var registrationButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(LocalizableConstants.Auth.registrationButton, for: .normal)
        element.setTitleColor(.blackDay, for: .normal)
        element.titleLabel?.font = .bodyBold
        element.titleLabel?.textAlignment = .center
        return element
    }()
}
