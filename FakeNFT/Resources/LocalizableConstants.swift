import Foundation

enum LocalizableConstants {
    enum Onboarding {
        static let firstTitle = NSLocalizedString("onboarding.firstTitle", comment: "")
        static let firstDescription = NSLocalizedString("onboarding.firstDescription", comment: "")
        static let secondTitle = NSLocalizedString("onboarding.secondTitle", comment: "")
        static let secondDescription = NSLocalizedString("onboarding.secondDescription", comment: "")
        static let thirdTitle = NSLocalizedString("onboarding.thirdTitle", comment: "")
        static let thirdDescription = NSLocalizedString("onboarding.thirdDescription", comment: "")
        static let letsStartButton = NSLocalizedString("onboarding.letsStartButton", comment: "")
    }
    
    enum TabBar {
        static let profile = NSLocalizedString("tabBar.profile", comment: "")
        static let catalog = NSLocalizedString("tabBar.catalog", comment: "")
        static let cart = NSLocalizedString("tabBar.cart", comment: "")
        static let statistics = NSLocalizedString("tabBar.statistics", comment: "")
    }
    
    enum Profile {
        static let myNFT = NSLocalizedString("profile.myNFT", comment: "")
        static let nftFavorites = NSLocalizedString("profile.nftFavorites", comment: "")
        static let aboutDeveloper = NSLocalizedString("profile.aboutDeveloper", comment: "")
        static let name = NSLocalizedString("profile.name", comment: "")
        static let changePhoto = NSLocalizedString("profile.changePhoto", comment: "")
        static let description = NSLocalizedString("profile.description", comment: "")
        static let website = NSLocalizedString("profile.website", comment: "")
        static let byAuthor = NSLocalizedString("profile.byAuthor", comment: "")
        static let price = NSLocalizedString("profile.price", comment: "")
        static let noNFT = NSLocalizedString("profile.noNFT", comment: "")
        static let noFavoritesNFT = NSLocalizedString("profile.noFavoritesNFT", comment: "")
    }
    
    enum Sort {
        static let sort = NSLocalizedString("sort.sort", comment: "")
        static let byName = NSLocalizedString("sort.byName", comment: "")
        static let byNFTQuantity = NSLocalizedString("sort.byNFTQuantity", comment: "")
        static let byPrice = NSLocalizedString("sort.byPrice", comment: "")
        static let byRating = NSLocalizedString("sort.byRating", comment: "")
        static let byTitle = NSLocalizedString("sort.byTitle", comment: "")
        static let close = NSLocalizedString("sort.close", comment: "")
    }
    
    enum Catalog {
        static let author = NSLocalizedString("catalog.author", comment: "")
    }
    
    enum Cart {
        static let price = NSLocalizedString("cart.price", comment: "")
        static let delete = NSLocalizedString("cart.delete", comment: "")
        static let goBack = NSLocalizedString("cart.goBack", comment: "")
        static let deleteQuestion = NSLocalizedString("cart.deleteQuestion", comment: "")
        static let checkout = NSLocalizedString("cart.checkout", comment: "")
        static let pay = NSLocalizedString("cart.pay", comment: "")
        static let paymentMethod = NSLocalizedString("cart.paymentMethod", comment: "")
        static let terms = NSLocalizedString("cart.terms", comment: "")
        static let conditions = NSLocalizedString("cart.conditions", comment: "")
        static let backToCatalog = NSLocalizedString("cart.backToCatalog", comment: "")
        static let tryAgain = NSLocalizedString("cart.tryAgain", comment: "")
        static let emptyCart = NSLocalizedString("cart.emptyCart", comment: "")
        static let successfulPayment = NSLocalizedString("cart.successfulPayment", comment: "")
        static let failedPayment = NSLocalizedString("cart.failedPayment", comment: "")
    }
    
    enum Statistics {
        static let nftCollection = NSLocalizedString("statistics.nftCollection", comment: "")
        static let userWebsite = NSLocalizedString("statistics.userWebsite", comment: "")
    }
}
