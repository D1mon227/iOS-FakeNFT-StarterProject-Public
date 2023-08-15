import UIKit

enum Resourses {
    enum Images {
        enum Onboarding {
            static let firstScreen = UIImage(named: "firstScreen")
            static let secondScreen = UIImage(named: "secondScreen")
            static let thirdScreen = UIImage(named: "thirdScreen")
        }
        
        enum NFT {
            static let nftCard1 = UIImage(named: "NFT card 1")
            static let nftCard2 = UIImage(named: "NFT card 2")
            static let nftCard3 = UIImage(named: "NFT card 3")
        }
        
        enum Crypto {
            static let apeCoin = UIImage(named: "ApeCoin (APE)")
            static let bitcoin = UIImage(named: "Bitcoin (BTC)")
            static let cardano = UIImage(named: "Cardano (ADA)")
            static let dogecoin = UIImage(named: "Dogecoin (DOGE)")
            static let ethereum = UIImage(named: "Ethereum (ETH)")
            static let shibaInu = UIImage(named: "Shiba Inu (SHIB)")
            static let solana = UIImage(named: "Solana (SOL)")
            static let tether = UIImage(named: "Tether (USDT)")
        }
        
        enum Profile {
            static let profileImage = UIImage(named: "profile Image")
            static let profilePlaceholser = UIImage(named: "placeholderImage")
        }
        
        enum TabBar {
            static let profileTabBar = UIImage(systemName: "person.crop.circle.fill")
            static let catalogTabBar = UIImage(systemName: "rectangle.stack.fill")
            static let cartTabBar = UIImage(named: "Cart")
            static let statisticsTabBar = UIImage(systemName: "flag.2.crossed.fill")
        }
        
        enum Button {
            static let backButton = UIImage(systemName: "chevron.backward")
            static let forwardButton = UIImage(systemName: "chevron.forward")
            static let closeButton = UIImage(systemName: "xmark")
        }
        
        enum Cell {
            static let like = UIImage(systemName: "heart.fill")
            static let star = UIImage(systemName: "star.fill")
			static let cart = UIImage(named: "cart")
			static let cartFill = UIImage(named: "cart.fill")
        }
        
        enum Sort {
            static let sort = UIImage(named: "Sort")
        }
        
        enum NetworkError {
            static let noInternet = UIImage(systemName: "noInternet")
            static let errorNetwork = UIImage(systemName: "errorNetwork")
        }
    }
}
