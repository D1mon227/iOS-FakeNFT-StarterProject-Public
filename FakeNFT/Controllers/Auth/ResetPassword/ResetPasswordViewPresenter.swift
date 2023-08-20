import Foundation
import Firebase

final class ResetPasswordViewPresenter: ResetPasswordViewPresenterProtocol {
    weak var view: ResetPasswordViewControllerProtocol?
    private var email: String?
    private var didResetPasswordSuccess: Bool? {
        didSet {
            guard let value = self.didResetPasswordSuccess else { return }
            view?.checkPasswordReset(successfulReset: value)
        }
    }
    
    func setupEmail(email: String?) {
        self.email = email
    }
    
    func resetPassword() {
        if let email = email {
            Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
                guard let self = self else { return }
                if error != nil {
                    self.didResetPasswordSuccess = true
                } else {
                    self.didResetPasswordSuccess = false
                }
            }
        } else {
            view?.showNewPlaceholder()
        }
    }
}
