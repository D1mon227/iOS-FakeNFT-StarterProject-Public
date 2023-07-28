import Foundation

enum LocalizableConstants {
    enum TabBar {
        static let profile = NSLocalizedString("tabBar.profile", comment: "")
        static let catalog = NSLocalizedString("tabBar.catalog", comment: "")
        static let cart = NSLocalizedString("tabBar.cart", comment: "")
        static let statistics = NSLocalizedString("tabBar.statistics", comment: "")
    }
    
    enum Profile {
        static let myNFT = NSLocalizedString("profile.myNFT", comment: "")
        static let favoritesNFT = NSLocalizedString("profile.NFTfavorites", comment: "")
        static let aboutDeveloper = NSLocalizedString("profile.aboutDeveloper", comment: "")
        static let name = NSLocalizedString("profile.name", comment: "")
        static let description = NSLocalizedString("profile.description", comment: "")
        static let website = NSLocalizedString("profile.website", comment: "")
        static let price = NSLocalizedString("profile.price", comment: "")
    }
    
    enum Sorting {
        static let sorting = NSLocalizedString("sorting.sorting", comment: "")
        static let byName = NSLocalizedString("profile.byName", comment: "")
    }
}
