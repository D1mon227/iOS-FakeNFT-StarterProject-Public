import UIKit

protocol IRegistrationView: AnyObject {
	func setDelegateTextField(delegate: UITextFieldDelegate)
}

final class RegistrationView: UIView {
	var onEnterButtonTapped: ((String, String) -> Void)?
	var presenter: IRegistrationViewPresenter?
	
	private let entryLabel: UILabel = {
		let label = UILabel()
		label.textColor = .blackDay
		label.font = .headline1
		label.textAlignment = .left
		label.text = LocalizableConstants.Auth.registrationTitle
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let emailTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = LocalizableConstants.Auth.emailPlaceholder
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
		textField.font = .bodyRegular
		textField.textColor = .blackDay
		textField.backgroundColor = .lightGreyDay
		textField.autocapitalizationType = .none
		textField.leftViewMode = .always
		textField.clearButtonMode = .whileEditing
		textField.layer.cornerRadius = 12
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private let passwordTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = LocalizableConstants.Auth.passwordPlaceholder
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
		textField.textColor = .blackDay
		textField.backgroundColor = .lightGreyDay
		textField.isSecureTextEntry = true
		textField.autocapitalizationType = .none
		textField.leftViewMode = .always
		textField.clearButtonMode = .whileEditing
		textField.layer.cornerRadius = 12
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private lazy var loginPasswordMistakeLabel: UILabel = {
		let label = UILabel()
		label.text = LocalizableConstants.Auth.incorrectUsernameOrPasswordLabel
		label.textColor = .redUniversal
		label.font = .caption2
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let weakPasswordLabel: UILabel = {
		let label = UILabel()
		label.text = LocalizableConstants.Auth.weakPasswordLabel
		label.textColor = .redUniversal
		label.font = .caption2
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let invalidEmailLabel: UILabel = {
		let label = UILabel()
		label.text = LocalizableConstants.Auth.invalidEmailLabel
		label.textColor = .redUniversal
		label.font = .caption2
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let emailAlreadyInUseLabel: UILabel = {
		let label = UILabel()
		label.text = LocalizableConstants.Auth.usernameAlreadyExistsLabel
		label.textColor = .redUniversal
		label.font = .caption2
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var enterButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle(LocalizableConstants.Auth.registrationButton, for: .normal)
		button.backgroundColor = .blackDay
		button.setTitleColor(.backgroundDay, for: .normal)
		button.titleLabel?.font = .bodyBold
		button.titleLabel?.textAlignment = .center
		button.layer.cornerRadius = 16
		button.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	@objc private func enterButtonTapped(_ sender: UIButton) {
		let email = emailTextField.text ?? ""
		let password = passwordTextField.text ?? ""
		presenter?.registrationUser(with: email, password: password)
	}
	
	init() {
		super.init(frame: .zero)
		self.configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func showMistakeLabel()	 {
		self.addSubview(loginPasswordMistakeLabel)
		NSLayoutConstraint.activate([
			loginPasswordMistakeLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
			loginPasswordMistakeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			loginPasswordMistakeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
		])
	}
	
	func showWeakPasswordLabel() {
		addSubview(weakPasswordLabel)
		NSLayoutConstraint.activate([
			weakPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
			weakPasswordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			weakPasswordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
		])
	}
	
	func showInvalidEmailLabel() {
		addSubview(invalidEmailLabel)
		NSLayoutConstraint.activate([
			invalidEmailLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
			invalidEmailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			invalidEmailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
		])
	}
	
	func showEmailAlreadyInUseLabel() {
		addSubview(emailAlreadyInUseLabel)
		NSLayoutConstraint.activate([
			emailAlreadyInUseLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
			emailAlreadyInUseLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			emailAlreadyInUseLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
		])
	}
	
	private func hideWeakPasswordLabel() {
		weakPasswordLabel.removeFromSuperview()
	}
	
	private func hideInvalidEmailLabel() {
		invalidEmailLabel.removeFromSuperview()
	}
	
	private func hideEmailAlreadyInUseLabel() {
		emailAlreadyInUseLabel.removeFromSuperview()
	}
	
	private func hideMistakeLabel() {
		loginPasswordMistakeLabel.removeFromSuperview()
	}
}

extension RegistrationView: IRegistrationView {
	func setDelegateTextField(delegate: UITextFieldDelegate) {
		emailTextField.delegate = self
		passwordTextField.delegate = self
	}
}

private extension RegistrationView {
	func configureView() {
		self.backgroundColor = UIColor.backgroundDay
		self.addSubview(entryLabel)
		self.addSubview(emailTextField)
		self.addSubview(passwordTextField)
		self.addSubview(enterButton)
		
		NSLayoutConstraint.activate([
			entryLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 88),
			entryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			entryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			
			emailTextField.topAnchor.constraint(equalTo: entryLabel.bottomAnchor, constant: 50),
			emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			emailTextField.heightAnchor.constraint(equalToConstant: 44),
			
			passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 18),
			passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			passwordTextField.heightAnchor.constraint(equalToConstant: 44),
			
			enterButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 86),
			enterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			enterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			enterButton.heightAnchor.constraint(equalToConstant: 60)
		])
	}
}

extension RegistrationView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if !string.isEmpty {
			hideMistakeLabel()
			hideWeakPasswordLabel()
			hideInvalidEmailLabel()
			hideEmailAlreadyInUseLabel()
		}
		return true
	}
}
