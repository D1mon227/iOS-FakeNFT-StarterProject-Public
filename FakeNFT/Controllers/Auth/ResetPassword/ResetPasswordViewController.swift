import UIKit
import SnapKit

final class ResetPasswordViewController: UIViewController, ResetPasswordViewControllerProtocol {
    var presenter: ResetPasswordViewPresenterProtocol?
    private let resetPasswordView = ResetPasswordView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = ResetPasswordViewPresenter()
        self.presenter?.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTarget()
        setupDelegate()
    }
    
    func checkPasswordReset(successfulReset: Bool) {
        UIBlockingProgressHUD.dismiss()
        successfulReset ? showInstractionLabel() : print("error")
    }
    
    private func setupTarget() {
        resetPasswordView.passwordResetButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        resetPasswordView.emailTextField.addTarget(self, action: #selector(setupEmail), for: [.editingChanged, .editingDidEnd])
    }
    
    private func setupDelegate() {
        resetPasswordView.emailTextField.delegate = self
    }
    
    private func showInstractionLabel() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.resetPasswordView.passwordResetButton.removeFromSuperview()
            view.addSubview(self.resetPasswordView.instractionsLabel)
            self.resetPasswordView.instractionsLabel.snp.makeConstraints { make in
                make.top.equalTo(self.resetPasswordView.emailTextField.snp.bottom).offset(18)
                make.leading.trailing.equalToSuperview().inset(16)
            }
        }
    }
    
    @objc private func setupEmail() {
        presenter?.setupEmail(email: resetPasswordView.emailTextField.text)
    }
    
    @objc private func resetPassword() {
        presenter?.resetPassword()
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
