import UIKit

final class UserDetailsViewController: UIViewController {
	private var userDetailsPresenter: IUserDetailsPresenter
	private let customView = UserDetailsView()
	
	init(with presenter: IUserDetailsPresenter) {
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
		customView.presenter = userDetailsPresenter
		customView.navigationController = self.navigationController
	}
}
