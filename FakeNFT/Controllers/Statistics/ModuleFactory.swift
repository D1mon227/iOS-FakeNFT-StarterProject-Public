import UIKit

struct ModuleFactory {
	static func makeProfileModule() -> ProfileViewController {
		let presenter = ProfileViewPresenter()
		let viewController = ProfileViewController(presenter: presenter)
		presenter.view = viewController

		return viewController
	}

	static func makeStatisticModule(appCoordinator: AppCoordinator) -> UIViewController {
		let networkManager = NetworkManager()
		let presenter = StatisticsPresenter(networkManager: networkManager, appCoordinator: appCoordinator)
		let view = StatisticsViewController(with: presenter)
		return view
	}
	
	static func makeUserDetailsModule(with user: User, appCoordinator: AppCoordinator) -> UIViewController {
		let presenter = UserDetailsPresenter(model: user, appCoordinator: appCoordinator)
		let view = UserDetailsViewController(with: presenter)
		return view
	}
	
	static func makeNFTCollectionModule(with user: User, appCoordinator: AppCoordinator) -> UIViewController {
		let networkManager = NetworkManager()
		let presenter = NFTCollectionPresenter(appCoordinator: appCoordinator, networkManager: networkManager, model: user)
		let view = NFTCollectionViewController(with: presenter)
		return view
	}
	
	static func makeWebViewModule(with url: URLRequest) -> WebViewController {
		let presenter = WebViewPresenter(urlRequest: url)
		let view = WebViewController(presenter: presenter)
		presenter.view = view
		return view
	}
	
	static func makeNFTCardModule(with nft: NFT, like: Bool) -> UIViewController {
		let view = NFTCardViewController(nftModel: nft, isLiked: like)
		return view
	}
}



