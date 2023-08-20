import Foundation
import FirebaseAuth

protocol IRegistrationViewPresenter {
	func viewDidLoad(ui: RegistrationView)
	func registrationUser(with email: String, password: String)
}

final class RegistrationViewPresenter {
	private weak var ui: RegistrationView?
	
	func registrationUser(with email: String, password: String) {
		if !email.isEmpty, !password.isEmpty {
			UIBlockingProgressHUD.show()
			Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
				UIBlockingProgressHUD.dismiss()
				if let error = error {
					print("Error creating user: \(error)")
				} else if let authResult = authResult {
					print("User registered successfully")
					// Продолжайте с дополнительными действиями после успешной регистрации
				}
			}
		} else {
			print("чего то не хватает!")
		}
	}
}

extension RegistrationViewPresenter: IRegistrationViewPresenter {
	func viewDidLoad(ui: RegistrationView) {
		self.ui = ui
		self.ui?.setDelegateTextField(delegate: ui)
	}
}
