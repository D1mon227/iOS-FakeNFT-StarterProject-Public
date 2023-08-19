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
    }
    
    private func setupDelegates() {
        authView.emailTextField.delegate = self
        authView.passwordTextField.delegate = self
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(132)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        authView.emailTextField.snp.makeConstraints { make in
            make.top.equalTo(authView.entryLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        authView.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(authView.emailTextField.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
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
