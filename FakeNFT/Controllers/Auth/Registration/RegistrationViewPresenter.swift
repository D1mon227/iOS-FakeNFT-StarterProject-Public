import Foundation
import FirebaseAuth

protocol IRegistrationViewPresenter {
	var navigationScreenDelegate: NavigationScreenDelegate? { get set }
	func viewDidLoad(ui: RegistrationView)
	func registrationUser(with email: String, password: String)
}

protocol NavigationScreenDelegate {
	func dismissRegistrationScreen()
}

final class RegistrationViewPresenter {
	private weak var ui: RegistrationView?
	var navigationScreenDelegate: NavigationScreenDelegate?
	
	func registrationUser(with email: String, password: String) {
		if !email.isEmpty, !password.isEmpty {
			Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
				if let error = error as NSError? {
					if error.code == AuthErrorCode.weakPassword.rawValue {
						self.ui?.showWeakPasswordLabel()
					} else if error.code == AuthErrorCode.invalidEmail.rawValue {
						self.ui?.showInvalidEmailLabel()
					} else if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
						self.ui?.showEmailAlreadyInUseLabel()
					}
				} else {
					UIBlockingProgressHUD.show()
					self.navigationScreenDelegate?.dismissRegistrationScreen()
				}
			}
		} else {
			self.ui?.showMistakeLabel()
		}
	}
}

extension RegistrationViewPresenter: IRegistrationViewPresenter {
	func viewDidLoad(ui: RegistrationView) {
		self.ui = ui
		self.ui?.setDelegateTextField(delegate: ui)
	}
}
