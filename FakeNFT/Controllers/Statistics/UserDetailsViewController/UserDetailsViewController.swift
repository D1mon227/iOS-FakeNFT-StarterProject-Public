import UIKit

final class UserDetailsViewController: UIViewController {
	var userDetailsPresenter: UserDetailsPresenter
	private let customView = UserDetailsView()
	
	init(with presenter: UserDetailsPresenter) {
		self.userDetailsPresenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		self.view = self.customView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.userDetailsPresenter.viewDidLoad(ui: self.customView)
	}
}
