import Foundation

final class NFTCardViewPresenter: NFTCardViewPresenterProtocol {
    weak var view: NFTCardViewControllerProtocol?
    private let currencyService = CurrencyService.shared
    private let nftService = NFTService.shared
    private let likeService = LikeService.shared
    private let profileService = ProfileService.shared
    private let nftCollectionService = NFTCollectionService.shared
    
    var nftModel: NFT?
    var isLiked: Bool?
    
    var currencies: [Currency]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        }
    }
    
    var nfts: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadCollectionView()
            }
        }
    }
    
    var nftCollections: String? {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateNFTCollectionName(name: self.nftCollections ?? "")
            }
        }
    }
    
    private var likes: [String]?
    
    private var NFTUrls = [
        Resourses.Network.NFTUrls.bitcoin, Resourses.Network.NFTUrls.dogecoin,
        Resourses.Network.NFTUrls.tether, Resourses.Network.NFTUrls.apecoin,
        Resourses.Network.NFTUrls.solana, Resourses.Network.NFTUrls.ethereum,
        Resourses.Network.NFTUrls.cardano, Resourses.Network.NFTUrls.shibainu
    ]
    
    func fetchNFTCollections() {
        nftCollectionService.fetchNFTCollections { [weak self] result in
            guard let self = self,
                  let id = nftModel?.id else { return }
            switch result {
            case .success(let nftCollections):
                print(nftCollections)
                self.nftCollections = findNFTCollectionName(nftID: id, inCollections: nftCollections)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCurrencies() {
        currencyService.fetchCurrencies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencies):
                self.currencies = currencies
            case .failure(_):
                self.view?.showCurrencyErrorAlert()
            }
        }
    }
    
    func fetchNFTs() {
        nftService.fetchNFT { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                let randomIndexes = generateRandomNFTsIndexes(max: nfts.count, count: 5)
                self.nfts = randomIndexes.map { nfts[$0]}
            case .failure(_):
                self.view?.showNFTsErrorAlert()
            }
        }
    }
    
    func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.likes = profile.likes
            case .failure(_):
                self.view?.showErrorAlert()
            }
        }
    }
    
    func changeLike(_ id: String) {
        updateLikes(id)
        likeService.changeLike(newLike: Likes(likes: self.likes ?? [])) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.view?.showLikeErrorAlert(id: id)
            }
        }
    }
    
    func switchToNFTInformation(index: Int) -> WebViewController? {
        guard let url = URL(string: NFTUrls[index]) else { return nil }
        let webViewPresenter = WebViewPresenter(urlRequest: URLRequest(url: url))
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        
        return webViewController
    }
    
    func doesNftHasLike(id: String?) -> Bool {
        guard let id = id,
              let likes = likes else { return false }
        return likes.contains(id) ? true : false
    }
    
    func getCurrencyErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.fetchCurrencies()
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
    
    func getErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.fetchProfile()
        }
        return model
    }
    
    private func generateRandomNFTsIndexes(max: Int, count: Int) -> [Int] {
        guard max >= count else {
            fatalError("max must be greater than or equal to count")
        }
        var randomIndexes: Set<Int> = []
        
        while randomIndexes.count < count {
            let randomIndex = Int.random(in: 0..<max)
            randomIndexes.insert(randomIndex)
        }
        
        return Array(randomIndexes)
    }
    
    private func findNFTCollectionName(nftID: String, inCollections: [NFTCollection]) -> String? {
        for collection in inCollections {
            if let nfts = collection.nfts, nfts.contains(nftID) {
                return collection.name
            }
        }
        return nil
    }
    
    private func updateLikes(_ id: String) {
        guard var likes = likes else { return }
        if likes.contains(id) {
            likes.removeAll { $0 == id }
            self.likes = likes
        } else {
            likes.append(id)
            self.likes = likes
        }
    }
}
