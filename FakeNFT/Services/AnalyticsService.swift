import Foundation
import YandexMobileMetrica

enum Event: String {
    case open
    case close
    case click
}

enum Screen: String {
    //Profile
    case profileVC
    case editingProfileVC
    case myNFTsVC
    case favoritesNFTsVC
    
    //Catalog
    case catalogVC
    case catalogCollectionVC
    case authorVC
    case nftCardVC
    
    //Cart
    case cartVC
    case paymentMethodVC
    case successFailureVC
    
    //Statistics
    case statisticsVC
    case userCardVC
    case userCollectionVC
}

enum Item: String {
    //Profile
    case editProfile
    case myNFTs
    case favoriteNFTs
    case aboutDeveloper
    case profileWebsite
    case changePhoto
    case uploadPhoto
    
    //Catalog
    case authorWebsite
    
    //Cart
    case checkout
    case pay
    case returnToCatalog
    case tryAgain
    case userAgreement
    case removeNFT
    case currency
    
    //Statisctics
    case userInfo
    case userWebsite
    
    //Sort
    case sort
    case sortByName
    case sortByNFTQuantity
    case sortByPrice
    case sortByRating
    case sortByTitle
    
    //Joined
    case like
    case nftInfo
    case addToCart
    case currencyWebsite
    case nftCollection
}

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "5e198dee-59a7-4bc1-b44d-c96e3bd56dfa") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: Event, screen: Screen, item: Item?) {
        var params: [AnyHashable: Any] = [:]
        
        if item == nil {
            params = ["event": event.rawValue, "screen": screen.rawValue]
        } else {
            guard let item = item else { return }
            params = ["event": event.rawValue, "screen": screen.rawValue, "item": item.rawValue]
        }
        YMMYandexMetrica.reportEvent("EVENT", parameters: params) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
