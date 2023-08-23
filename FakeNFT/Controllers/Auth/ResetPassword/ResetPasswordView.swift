import UIKit

final class ResetPasswordView {
    lazy var passwordResetTitle: UILabel = {
        let element = UILabel()
        element.text = LocalizableConstants.Auth.resetPasswordTitle
        element.textColor = .blackDay
        element.font = .headline1
        element.textAlignment = .left
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
        element.textContentType = .oneTimeCode
        element.leftViewMode = .always
        element.clearButtonMode = .whileEditing
        element.layer.cornerRadius = 12
        return element
    }()
    
    lazy var instractionsLabel: UILabel = {
        let element = UILabel()
        element.text = LocalizableConstants.Auth.instructionsForResetPassword
        element.textColor = .greenUniversal
        element.font = .caption2
        element.textAlignment = .left
        element.numberOfLines = 0
        return element
    }()
    
    lazy var passwordResetButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle(LocalizableConstants.Auth.resetPasswordButton, for: .normal)
        element.backgroundColor = .blackDay
        element.setTitleColor(.backgroundDay, for: .normal)
        element.titleLabel?.font = .bodyBold
        element.titleLabel?.textAlignment = .center
        element.layer.cornerRadius = 16
        return element
    }()
}
