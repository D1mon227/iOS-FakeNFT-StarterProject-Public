import UIKit

final class AppCoordinator {
	private let tabBarController: TabBarController
	
	init(tabBarController: TabBarController) {
		self.tabBarController = tabBarController
	}
	
	func showUserDetails(user: User) {
		let userDetailsViewController = ModuleFactory.makeUserDetailsModule(with: user, appCoordinator: self)
		guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
		navigationController.pushViewController(userDetailsViewController, animated: true)
	}
	
	
	func showNFTCollectionScreen(user: User) {
		let nftCollectionViewController = ModuleFactory.makeNFTCollectionModule(with: user, appCoordinator: self)
		guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
		navigationController.pushViewController(nftCollectionViewController, animated: true)
	}
	
	func showWebViewScreen(url: URLRequest) {
		let webViewController = ModuleFactory.makeWebViewModule(with: url)
		guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
		navigationController.pushViewController(webViewController, animated: true)
	}
	
	func showNFTCardScreen(nft: NFT) {
		let nftCardViewController = ModuleFactory.makeNFTCardModule(with: nft)
		guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
		navigationController.pushViewController(nftCardViewController, animated: true)
	}
}
