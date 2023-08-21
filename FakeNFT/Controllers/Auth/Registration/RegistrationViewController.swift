import UIKit

final class RegistrationViewController: UIViewController, NavigationScreenDelegate {
	private var registrationViewPresenter: IRegistrationViewPresenter
	private let customView = RegistrationView()
	
	init(with presenter: IRegistrationViewPresenter) {
		self.registrationViewPresenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		self.view = self.customView
	}
	
	func dismissRegistrationScreen() {
		dismiss(animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.registrationViewPresenter.viewDidLoad(ui: self.customView)
		customView.presenter = registrationViewPresenter
		registrationViewPresenter.navigationScreenDelegate = self
	}
}
