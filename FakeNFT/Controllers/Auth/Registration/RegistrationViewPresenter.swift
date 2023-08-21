import Foundation
import FirebaseAuth

protocol IRegistrationViewPresenter {
	var navigationScreenDelegate: NavigationScreenDelegate? { get set }
	func viewDidLoad(ui: RegistrationView)
	func registrationUser(with email: String, password: String)
}

protocol NavigationScreenDelegate {
	func userRegistrationSuccessful()
}

final class RegistrationViewPresenter {
	private weak var ui: RegistrationView?
	var navigationScreenDelegate: NavigationScreenDelegate?
	
	func registrationUser(with email: String, password: String) {
		if !email.isEmpty, !password.isEmpty {
			UIBlockingProgressHUD.show()
			Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
				UIBlockingProgressHUD.dismiss()
				if let error = error {
					print("Error creating user: \(error)")
					self.ui?.showMistakeLabel()
				} else if let authResult = authResult {
					print("User registered successfully")
					self.navigationScreenDelegate?.userRegistrationSuccessful()
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
