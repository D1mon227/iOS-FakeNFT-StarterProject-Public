import UIKit
import SnapKit

final class ResetPasswordViewController: UIViewController {
    private let resetPasswordView = ResetPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: SetupViews
extension ResetPasswordViewController {
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(resetPasswordView.passwordResetTitle)
        view.addSubview(resetPasswordView.emailTextField)
        view.addSubview(resetPasswordView.passwordResetButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        resetPasswordView.passwordResetTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(88)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        resetPasswordView.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(resetPasswordView.passwordResetTitle.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
        resetPasswordView.passwordResetButton.snp.makeConstraints { make in
            make.top.equalTo(resetPasswordView.emailTextField.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
    }
}
