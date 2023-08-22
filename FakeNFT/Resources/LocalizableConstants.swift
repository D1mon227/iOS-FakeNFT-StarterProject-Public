import Foundation

enum LocalizableConstants {
    enum Auth {
        static let entryTitle = NSLocalizedString("auth.entryTitle", comment: "")
        static let emailPlaceholder = NSLocalizedString("auth.emailPlaceholder", comment: "")
        static let passwordPlaceholder = NSLocalizedString("auth.passwordPlaceholder", comment: "")
        static let enterButton = NSLocalizedString("auth.enterButton", comment: "")
        static let forgotPassword = NSLocalizedString("auth.forgotPassword", comment: "")
        static let demo = NSLocalizedString("auth.demo", comment: "")
        static let registrationButton = NSLocalizedString("auth.registrationButton", comment: "")
        static let registrationTitle = NSLocalizedString("auth.registrationTitle", comment: "")
        static let usernameAlreadyExistsLabel = NSLocalizedString("auth.usernameAlreadyExistsLabel", comment: "")
		static let invalidEmailLabel = NSLocalizedString("auth.invalidEmailLabel", comment: "")
		static let weakPasswordLabel = NSLocalizedString("auth.weakPasswordLabel", comment: "")
        static let incorrectUsernameOrPasswordLabel = NSLocalizedString("auth.incorrectUsernameOrPasswordLabel", comment: "")
        static let resetPasswordTitle = NSLocalizedString("auth.resetPasswordTitle", comment: "")
        static let resetPasswordButton = NSLocalizedString("auth.resetPasswordButton", comment: "")
        static let instructionsForResetPassword = NSLocalizedString("auth.instructionsForResetPassword", comment: "")
        
        enum Alert {
            static let title = NSLocalizedString("alert.title", comment: "")
            static let authMessage = NSLocalizedString("alert.authMessage", comment: "")
            static let failedLoadDataMessage = NSLocalizedString("alert.failedLoadDataMessage", comment: "")
            static let traAgainMessage = NSLocalizedString("alert.traAgainMessage", comment: "")
            static let okButton = NSLocalizedString("alert.okButton", comment: "")
            static let tryAgainButton = NSLocalizedString("alert.tryAgainButton", comment: "")
        }
    }
    
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
        static let uploadPhoto = NSLocalizedString("profile.uploadPhoto", comment: "")
        static let description = NSLocalizedString("profile.description", comment: "")
        static let website = NSLocalizedString("profile.website", comment: "")
        static let byAuthor = NSLocalizedString("profile.byAuthor", comment: "")
        static let price = NSLocalizedString("profile.price", comment: "")
        static let noNFT = NSLocalizedString("profile.noNFT", comment: "")
        static let noFavoritesNFT = NSLocalizedString("profile.noFavoritesNFT", comment: "")
        static let enterName = NSLocalizedString("profile.enterName", comment: "")
        static let enterDescription = NSLocalizedString("profile.enterDescription", comment: "")
        static let enterWebsite = NSLocalizedString("profile.enterWebsite", comment: "")
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
    
    enum NetworkErrorView {
        static let noInternet = NSLocalizedString("network.noInternet", comment: "")
        static let error = NSLocalizedString("network.error", comment: "")
        static let button = NSLocalizedString("network.button", comment: "")
    }
    
    enum NFTCard {
        static let addToCart = NSLocalizedString("nftcard.addToCart", comment: "")
        static let price = NSLocalizedString("nftcard.price", comment: "")
        static let sellerWebsite = NSLocalizedString("nftcard.sellerWebsite", comment: "")
    }
}
