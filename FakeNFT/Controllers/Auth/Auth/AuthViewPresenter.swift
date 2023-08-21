import Foundation
import Firebase

final class AuthViewPresenter: AuthViewPresenterProtocol {
    weak var view: AuthViewControllerProtocol?
    private var email: String?
    private var password: String?
    private var didAuthorizationSuccess: Bool? {
        didSet {
            guard let value = didAuthorizationSuccess else { return }
            view?.checkAuthorization(successfulAuthorization: value)
        }
    }
    
    private var loginPasswordMistake: Bool? {
        didSet {
            guard let value = loginPasswordMistake else { return }
            view?.checkLoginPasswordMistake(incorrect: value)
        }
    }
    
    func authorizeUser() {
        if let email = email,
           let password = password {
            UIBlockingProgressHUD.show()
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard let self = self else { return }
                if error != nil {
                    self.didAuthorizationSuccess = false
                }
                
                if user != nil {
                    self.didAuthorizationSuccess = true
                } else {
                    self.loginPasswordMistake = true
                }
            }
        } else {
            self.loginPasswordMistake = true
        }
    }
    
    func setupEmail(email: String?) {
        self.email = email
    }
    
    func setupPassword(password: String?) {
        self.password = password
    }
}
