import UIKit
import Firebase

final class ProfileViewController: UIViewController {
    override func viewDidDisappear(_ animated: Bool) {
        logout()
    }
    func logout() {
        do {
            try Auth.auth().signOut()
            print("Пользователь успешно разлогинен.")
            // Выполните перенаправление на экран авторизации или на другой экран по вашей логике
        } catch let signOutError as NSError {
            print("Ошибка при разлогинивании: (signOutError.localizedDescription)")
        }
    }
}
