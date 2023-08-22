import UIKit

struct ModuleFactory {
	static func makeStatisticModule(appCoordinator: AppCoordinator) -> UIViewController {
		let networkClient = DefaultNetworkClient()
		let presenter = StatisticsPresenter(networkClient: networkClient, appCoordinator: appCoordinator)
		let view = StatisticsViewController(with: presenter)
		return view
	}
	
	static func makeUserDetailsModule(with user: User, appCoordinator: AppCoordinator) -> UIViewController {
		let presenter = UserDetailsPresenter(model: user, appCoordinator: appCoordinator)
		let view = UserDetailsViewController(with: presenter)
		return view
	}
	
	static func makeNFTCollectionModule(with user: User, appCoordinator: AppCoordinator) -> UIViewController {
		let networkClient = DefaultNetworkClient()
		let presenter = NFTCollectionPresenter(appCoordinator: appCoordinator, networkClient: networkClient, model: user)
		let view = NFTCollectionViewController(with: presenter)
		return view
	}
	
	static func makeWebViewModule(with url: URLRequest) -> WebViewController {
		let presenter = WebViewPresenter(urlRequest: url)
		let view = WebViewController(presenter: presenter)
		presenter.view = view
		return view
	}
	
	static func makeNFTCardModule(with nft: NFT) -> UIViewController {
		let view = NFTCardViewController(nftModel: nft, isLiked: false)
		return view
	}
}



