import Foundation

final class NFTCardViewPresenter: NFTCardViewPresenterProtocol {
    weak var view: NFTCardViewControllerProtocol?
    private let networkManager = NetworkManager()
    
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
    private var order: [String]?
    
    private var NFTUrls = [
        Resourses.Network.NFTUrls.bitcoin, Resourses.Network.NFTUrls.dogecoin,
        Resourses.Network.NFTUrls.tether, Resourses.Network.NFTUrls.apecoin,
        Resourses.Network.NFTUrls.solana, Resourses.Network.NFTUrls.ethereum,
        Resourses.Network.NFTUrls.cardano, Resourses.Network.NFTUrls.shibainu
    ]
    
    func fetchData() {
        fetchProfile()
        fetchNFTs()
        fetchCurrencies()
        fetchNFTCollections()
        fetchCart()
    }
    
    func changeLike(_ id: String) {
        updateLikes(id)
        
        UIBlockingProgressHUD.show()
        let request = ProfilePutRequest(dto: Likes(likes: self.likes ?? []))
        networkManager.send(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.view?.showLikeErrorAlert(id: id)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func addNftToCard(_ id: String) {
        updateCart(id)
        UIBlockingProgressHUD.show()
        let request = CartPutRequest(dto: Order(nfts: self.order ?? [], id: "1"))
        networkManager.send(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.view?.showCartErrorAlert(id: id)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func switchToNFTInformation(index: Int) -> WebViewController? {
        guard let url = URL(string: NFTUrls[index]) else { return nil }
        let webViewPresenter = WebViewPresenter(urlRequest: URLRequest(url: url))
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        
        return webViewController
    }
    
    func doesNftHaveLike(id: String?) -> Bool {
        guard let id = id,
              let likes = likes else { return false }
        return likes.contains(id) ? true : false
    }
    
    func isNftInCart(id: String?) -> Bool {
        guard let id = id,
              let order = order else { return false }
        return order.contains(id) ? true : false
    }
    
    func getCurrencyErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.cancelButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.fetchCurrencies()
        }
        return model
    }
    
    func getNFTsErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.cancelButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.fetchNFTs()
        }
        return model
    }
    
    func getLikeErrorModel(id: String) -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.traAgainMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.okButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.changeLike(id)
        }
        return model
    }
    
    func getProfileErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.cancelButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.fetchProfile()
        }
        return model
    }
    
    func getNftCollectionErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.cancelButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.fetchNFTCollections()
        }
        return model
    }
    
    func getNCartErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.cancelButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.fetchCart()
        }
        return model
    }
    
    func getCartErrorModel(id: String) -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.traAgainMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.okButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.changeLike(id)
        }
        return model
    }
    
    
    private func fetchNFTCollections() {
        UIBlockingProgressHUD.show()
        let request = NFTCollectionGetRequest()
        networkManager.send(request: request, type: [NFTCollection].self) { [weak self] result in
            guard let self = self,
                  let id = nftModel?.id else { return }
            switch result {
            case .success(let nftCollections):
                self.nftCollections = findNFTCollectionName(nftID: id, inCollections: nftCollections)
            case .failure(_):
                self.view?.showNftCollectionErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchCurrencies() {
        UIBlockingProgressHUD.show()
        let request = CurrencyGetRequest()
        networkManager.send(request: request, type: [Currency].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencies):
                self.currencies = currencies
            case .failure(_):
                self.view?.showCurrencyErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchNFTs() {
        UIBlockingProgressHUD.show()
        let request = NFTsGetRequest()
        networkManager.send(request: request, type: [NFT].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                let randomIndexes = generateRandomNFTsIndexes(max: nfts.count, count: 5)
                self.nfts = randomIndexes.map { nfts[$0]}
            case .failure(_):
                self.view?.showNFTsErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        let request = ProfileGetRequest()
        networkManager.send(request: request, type: Profile.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.likes = profile.likes
            case .failure(_):
                self.view?.showProfileErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchCart() {
        UIBlockingProgressHUD.show()
        let request = CartGetRequest()
        networkManager.send(request: request, type: Order.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = order.nfts
            case .failure(_):
                self.view?.showCartErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
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
    
    private func updateCart(_ id: String) {
        guard var order = order else { return }
        if order.contains(id) {
            order.removeAll { $0 == id }
            self.order = order
        } else {
            order.append(id)
            self.order = order
        }
    }
}
