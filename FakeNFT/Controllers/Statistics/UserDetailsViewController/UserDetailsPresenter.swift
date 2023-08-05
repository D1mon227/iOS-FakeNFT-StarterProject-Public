import UIKit

protocol IUserDetailsPresenter {
	func viewDidLoad(ui: UserDetailsView)
}

final class UserDetailsPresenter {
	var ui: UserDetailsView?
	private var model: User?
	
	init(user: User?) {
		self.model = user
	}
}

extension UserDetailsPresenter: IUserDetailsPresenter {
	func viewDidLoad(ui: UserDetailsView) {
		self.ui = ui
		self.ui?.setDelegateDataSource(delegate: ui)
		guard let user = model else { return }
		self.ui?.updateUI(with: user)
	}
}
