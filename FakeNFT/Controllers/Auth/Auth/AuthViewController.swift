import UIKit
import SnapKit

final class AuthViewController: UIViewController, AuthViewControllerProtocol {
    var presenter: AuthViewPresenterProtocol?
    private let authView = AuthView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = AuthViewPresenter()
        self.presenter?.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        setupTargets()
    }
    
    func checkAuthorization(successfulAuthorization: Bool) {
        UIBlockingProgressHUD.dismiss()
        successfulAuthorization ? switchToOnboarding() : print("bf")
    }
    
    func checkLoginPasswordMistake(incorrect: Bool) {
        UIBlockingProgressHUD.dismiss()
        incorrect ? showMistakeLabel() : hideMistakeLabel()
    }
    
    private func setupDelegates() {
        authView.emailTextField.delegate = self
        authView.passwordTextField.delegate = self
    }
    
    private func setupTargets() {
        authView.enterButton.addTarget(self, action: #selector(authorizeUser), for: .touchUpInside)
        authView.registrationButton.addTarget(self, action: #selector(switchToRegistrationVC), for: .touchUpInside)
        authView.forgotPasswordButton.addTarget(self, action: #selector(switchToResetPasswordVC), for: .touchUpInside)
        authView.emailTextField.addTarget(self, action: #selector(setupEmail), for: [.editingChanged, .editingDidEnd])
        authView.passwordTextField.addTarget(self, action: #selector(setupPassword), for: [.editingChanged, .editingDidEnd])
    }
    
    private func switchToOnboarding() {
        let onboarding = OnboardingPageViewController()
        onboarding.modalPresentationStyle = .fullScreen
        onboarding.modalTransitionStyle = .flipHorizontal
        present(onboarding, animated: true)
    }
    
    private func showMistakeLabel() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            view.addSubview(self.authView.loginPasswordMistakeLabel)
            self.authView.loginPasswordMistakeLabel.snp.makeConstraints { make in
                make.top.equalTo(self.authView.passwordTextField.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(16)
            }
            self.authView.emailTextField.layer.borderWidth = 1
            self.authView.emailTextField.layer.borderColor = UIColor.redUniversal.cgColor
            self.authView.passwordTextField.layer.borderWidth = 1
            self.authView.passwordTextField.layer.borderColor = UIColor.redUniversal.cgColor
        }
    }
    
    private func hideMistakeLabel() {
        authView.emailTextField.layer.borderWidth = 0
        authView.passwordTextField.layer.borderWidth = 0
        authView.loginPasswordMistakeLabel.removeFromSuperview()
    }
    
    @objc private func authorizeUser() {
        presenter?.authorizeUser()
    }
    
    @objc private func setupEmail() {
        presenter?.setupEmail(email: authView.emailTextField.text)
    }
    
    @objc private func setupPassword() {
        presenter?.setupPassword(password: authView.passwordTextField.text)
    }
    
    @objc private func switchToResetPasswordVC() {
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let resetPasswordVC = ResetPasswordViewController()
        customNC.pushViewController(resetPasswordVC, animated: true)
    }
    
    @objc private func switchToRegistrationVC() {
        guard let customNC = navigationController as? CustomNavigationController else { return }
        let registrationPresenter = RegistrationViewPresenter()
        let registrationVC = RegistrationViewController(with: registrationPresenter)
        customNC.pushViewController(registrationVC, animated: true)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.hideMistakeLabel()
        }
    }
}

//MARK: SetupViews
extension AuthViewController {
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(authView.entryLabel)
        view.addSubview(authView.emailTextField)
        view.addSubview(authView.passwordTextField)
        view.addSubview(authView.enterButton)
        view.addSubview(authView.forgotPasswordButton)
        view.addSubview(authView.demoButton)
        view.addSubview(authView.registrationButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        authView.entryLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(88)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        authView.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(authView.entryLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
        authView.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(authView.emailTextField.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
        authView.enterButton.snp.makeConstraints { make in
            make.top.equalTo(authView.passwordTextField.snp.bottom).offset(86)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        authView.forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(authView.enterButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        authView.demoButton.snp.makeConstraints { make in
            make.top.equalTo(authView.forgotPasswordButton.snp.bottom).offset(67)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        authView.registrationButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(authView.demoButton.snp.bottom).offset(12)
            make.height.equalTo(60)
        }
    }
}
