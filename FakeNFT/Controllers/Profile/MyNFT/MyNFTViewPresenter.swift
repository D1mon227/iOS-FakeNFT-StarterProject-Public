import Foundation

final class MyNFTViewPresenter: MyNFTViewPresenterProtocol {
    weak var view: MyNFTViewControllerProtocol?
    var profilePresenter: ProfileViewPresenterProtocol?
    private let nftService = NFTService.shared
    private let userService = UserService.shared
    private let likeService = LikeService.shared
    private let analyticsService = AnalyticsService.shared
    private let userDefaults = UserDefaults.standard
    private let sortUserDefaultsKey = "MyNFtSortKey"
    
    var likes: [String]?
    var purchasedNFTs: [NFT] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadViews()
            }
        }
    }
    
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadViews()
            }
        }
    }
    
    private var currentSort: Sort {
        get {
            if let savedSort = userDefaults.string(forKey: sortUserDefaultsKey) {
                return Sort(rawValue: savedSort) ?? .byRating
            } else {
                return .byRating
            }
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: sortUserDefaultsKey)
        }
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    func fetchNFTs() {
        nftService.fetchNFT { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                guard let profile = profilePresenter?.profile else { return }
                self.purchasedNFTs = filterPurchasedNFTs(profile: profile, allNFTs: nfts)
                self.sortNFT(by: currentSort)
            case .failure(_):
                self.view?.showNFTsErrorAlert()
            }
        }
    }
    
    func fetchUsers() {
        userService.fetchUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users = users
            case .failure(_):
                self.view?.showUsersErrorAlert()
            }
        }
    }
    
    func changeLike(_ id: String) {
        guard var likes = likes else { return }
        if likes.contains(id) {
            likes.removeAll { $0 == id }
            self.likes = likes
        } else {
            likes.append(id)
            self.likes = likes
        }
            
        likeService.changeLike(newLike: Like(likes: self.likes)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newProfile):
                self.profilePresenter?.profile = newProfile
            case .failure(_):
                self.view?.showLikeErrorAlert(id: id)
            }
        }
    }
    
    func getAuthorName(for authorID: String, from authors: [User]) -> String? {
        let author = authors.first(where: { $0.id == authorID })
        return author?.name
    }
    
    func arePurchasedNFTsEmpty() -> Bool {
        purchasedNFTs.isEmpty ? true : false
    }
    
    func doesNftHasLike(id: String?) -> Bool {
        guard let id = id,
              let likes = likes else { return false }
        return likes.contains(id) ? true : false
    }
    
    func sortNFT(by: Sort) {
        var nfts = purchasedNFTs
        
        switch by {
        case .byPrice:
            nfts.sort { $0.price ?? 0.0 > $1.price ?? 0.0 }
            analyticsService.report(event: .click, screen: .myNFTsVC, item: .sortByPrice)
            currentSort = .byPrice
        case .byRating:
            nfts.sort { $0.rating ?? 0 > $1.rating ?? 0 }
            analyticsService.report(event: .click, screen: .myNFTsVC, item: .sortByRating)
            currentSort = .byRating
        case .byTitle:
            nfts.sort { $0.name ?? "" < $1.name ?? "" }
            analyticsService.report(event: .click, screen: .myNFTsVC, item: .sortByTitle)
            currentSort = .byTitle
        default:
            break
        }
        
        self.purchasedNFTs = nfts
    }
    
    func getSortModel() -> AlertSortModel {
        let sortingOptions: [Sort] = [.byPrice, .byRating, .byTitle, .close]
        let model = AlertSortModel(title: LocalizableConstants.Sort.sort,
                                   actions: sortingOptions) { [weak self] option in
            guard let self = self else { return }
            self.sortNFT(by: option)
        }
        return model
    }
    
    func getUsersErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.fetchUsers()
        }
        return model
    }
    
    func getNFTsErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.fetchNFTs()
        }
        return model
    }
    
    func getLikeErrorModel(id: String) -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.traAgainMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.changeLike(id)
        }
        return model
    }
    
    private func filterPurchasedNFTs(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        guard let profileNFTIds = profile.nfts else { return [] }

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id ?? "")
        }

        return filteredNFTs
    }
}
