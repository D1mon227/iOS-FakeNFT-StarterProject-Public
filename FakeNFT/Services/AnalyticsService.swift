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
    case profileWebsiteVC
    case aboutDeveloperVC
    
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
    case userWebsiteVC
}

enum Item: String {
    //Profile
    case editProfile
    case myNFTs
    case favoriteNFTs
    case aboutDeveloper
    case profileWebsite
    case changePhoto
    
    //Catalog
    case author
    case collection
    
    //Statisctics
    case userOnfo
    case userWebsite
    case nftCollection
    
    //Sort
    case sort
    case sortByName
    case sortByNFTQuantity
    case sortByPrice
    case sortByRating
    case sortByTitle
    
    //Like
    case like
    
    //Joined
    case nftInfo
    case addToCart
    case currencyWebsite
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
