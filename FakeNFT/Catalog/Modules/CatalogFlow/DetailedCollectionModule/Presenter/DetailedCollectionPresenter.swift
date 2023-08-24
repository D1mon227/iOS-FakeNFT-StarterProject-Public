import Foundation

final class DetailedCollectionPresenter {
    
    weak var view: DetailedCollectionViewProtocol?
    private let response: NFTCollection
    private var nftsModels = [NFTCollectionViewCellViewModel]()
    private var nftsResponses = [NFT]()
    private var detailsCollectionModel: CollectionDetailsCollectionViewCellModel?
    private var nftsInCart: [String]?
    private var userLikes: [String]?
    private var user: Profile?
    private let group = DispatchGroup()
    private let networkManager: NetworkManager
    
    let connectionAvailableKey = NetworkReachabilityManager.shared.connectionAvailableKey
    
    init(networkManager: NetworkManager, response: NFTCollection) {
        self.networkManager = networkManager
        self.response = response
    }
}

extension DetailedCollectionPresenter: DetailedCollectionPresenterProtocol {
    func viewDidLoad() {
        subscribe()
        view?.showLoadingIndicator()
        getNftAuthor()
        getNft(by: response.nfts ?? [])
    }
    
    func viewDidAppear() {
        sendAnalytics(event: .open)
    }
    
    func viewDidDisappear() {
        sendAnalytics(event: .close)
    }
    
    func didTapOnLink(url: String?) {
        guard let url = URL(string: url ?? "") else { return }
        let urlRequest = URLRequest(url: url)
        let presenter = WebViewPresenter(urlRequest: urlRequest)
        let vc = WebViewController(presenter: presenter)
        vc.hidesBottomBarWhenPushed = true
        presenter.view = vc
        view?.present(vc)
        sendAnalytics(event: .click, item: .authorWebsite)
    }
    
    func didTapCartButton(id: String) {
        updateCart(id)
        self.nftsModels = self.nftsModels.compactMap { model in
            let isCartAdded = nftsInCart?.contains(model.nftId)
            guard let imageModel = makeCartImageModel(isCartAdded: isCartAdded ?? false) else {
                return nil
            }
            let newModel = model.makeNewModel(cartButtonImageName: imageModel)
            return newModel
        }
        
        view?.updateNftsModel(with: nftsModels)
        putCartOrder(id: id)
        
        sendAnalytics(event: .click, item: .addToCart)
    }
    
    func didTapLikeButton(id: String) {
        updateLikes(id)
        self.nftsModels = self.nftsModels.compactMap { model in
            let isFavorite = userLikes?.contains(model.nftId)
            guard let imageModel = makeLikeImageModel(isFavorite: isFavorite ?? false) else {
                return nil
            }
            let newModel = model.makeNewModel(favoriteButtonImageName: imageModel)
            return newModel
        }
        
        view?.updateNftsModel(with: nftsModels)
        
        putFavorites()
        sendAnalytics(event: .click, item: .like)
    }
    
    func didChooseNft(with id: String) {
        guard let response = nftsResponses.first(where: { $0.id == id }) else {
            return
        }
        
        let formattedPrice = response.price
        
        let nft = NFT(createdAt: response.createdAt,
                      name: response.name,
                      images: response.images,
                      rating: response.rating,
                      description: response.description,
                      price: formattedPrice,
                      author: response.author,
                      id: response.id)
        
        let isLiked = userLikes?.contains(id)
        
        let viewController = NFTCardViewController(nftModel: nft, isLiked: isLiked ?? false)
        view?.present(viewController)
        
        sendAnalytics(event: .click, item: .nftInfo)
        
        
    }
}

private extension DetailedCollectionPresenter {
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: NetworkReachabilityManager.shared.networkReachabilityManagerNotification,
                                               object: nil)
    }
    
    @objc
    func handleNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        
        guard let connectionAvailable = userInfo[connectionAvailableKey] as? Bool else {
            return
        }
        
        if connectionAvailable {
            self.resetState()
        } else {
            let model = NetworkErrorViewModel(networkErrorImage:
                                                Resourses.Images.NetworkError.noInternet,
                                              notificationNetworkTitle: LocalizableConstants.NetworkErrorView.noInternet)  { [weak self] in
                guard let self else { return }
                self.resetState()
            }
            self.view?.showNetworkError(model: model)
        }
        self.view?.hideLoadingIndicator()
    }
    
    func getNftAuthor() {
        let request = ProfileGetRequest()
        networkManager.send(request: request, type: Profile.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.user = user
                self.detailsCollectionModel = makeViewModel(user: user)
                guard let detailsCollectionModel else { return }
                self.view?.updateDetailsCollectionModel(with: detailsCollectionModel)
                self.view?.hideNetworkError()
            case .failure:
                self.showRequestError()
            }
        }
    }
    
    func getNft(by ids: [String]) {
        ids.forEach { id in
            group.enter()
            let request = NFTsGetRequestByID(nftId: id)
            networkManager.send(request: request, type: NFT.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    nftsResponses.append(response)
                    let viewModel = NFTCollectionViewCellViewModel(nftResponse: response)
                    self.nftsModels.append(viewModel)
                    self.view?.hideNetworkError()
                case .failure:
                    showRequestError()
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self else { return }
            self.getProfile()
            self.getCartOrders()
            self.view?.hideLoadingIndicator()
        }
        
    }
    
    func getCartOrders() {
        let request = CartGetRequest()
        networkManager.send(request: request, type: Order.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cart):
                self.nftsInCart = cart.nfts
                self.nftsModels = self.nftsModels.compactMap { model in
                    let isCartAdded = self.nftsInCart?.contains(model.nftId)
                    guard let imageModel = self.makeCartImageModel(isCartAdded: isCartAdded ?? false) else {
                        return nil
                    }
                    let newModel = model.makeNewModel(cartButtonImageName: imageModel)
                    return newModel
                }
                view?.updateNftsModel(with: nftsModels)
                self.view?.hideNetworkError()
            case .failure:
                showRequestError()
            }
        }
    }
    
    func putCartOrder(id: String) {
        let request = CartPutRequest(dto: Order(nfts: self.nftsInCart ?? [], id: "1"))
        networkManager.send(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.hideNetworkError()
            case .failure:
                self.showRequestError()
            }
        }
    }
    
    func putFavorites() {
        let request = ProfilePutRequest(dto: Likes(likes: self.userLikes ?? []))
        networkManager.send(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.hideNetworkError()
            case .failure:
                self.showRequestError()
            }
        }
    }
    
    func getProfile() {
        let request = ProfileGetRequest()
        networkManager.send(request: request, type: Profile.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.userLikes = user.likes
                self.nftsModels = self.nftsModels.compactMap { model in
                    let isFavorite = self.userLikes?.contains(model.nftId)
                    guard let imageModel = self.makeLikeImageModel(isFavorite: isFavorite ?? false) else {
                        return nil
                    }
                    let newModel = model.makeNewModel(favoriteButtonImageName: imageModel)
                    return newModel
                }
                self.view?.updateNftsModel(with: nftsModels)
            case .failure:
                showRequestError()
            }
        }
    }
    
    func makeViewModel(user: Profile) -> CollectionDetailsCollectionViewCellModel {
        return CollectionDetailsCollectionViewCellModel(collectionId: response.id ?? "",
                                                        collectionDescription: response.description ?? "",
                                                        collectionName: response.name ?? "",
                                                        imageStringUrl: response.cover?.makeUrl(),
                                                        user: user)
        
    }
    
    func sendAnalytics(event: Event, item: Item? = nil) {
        AnalyticsService.shared.report(event: event,
                                       screen: .catalogCollectionVC,
                                       item: item)
    }
    
    func makeLikeImageModel(isFavorite: Bool) -> ImageModel? {
        guard let image = Resourses.Images.Cell.like else {
            return nil
        }
        let imageModel = ImageModel(image: image,
                                    color: isFavorite ? .redUniversal : .white)
        return imageModel
    }
    
    func makeCartImageModel(isCartAdded: Bool) -> ImageModel? {
        guard let image = isCartAdded ? Resourses.Images.Cell.cartFill : Resourses.Images.Cell.cart else {
            return nil
        }
        let imageModel = ImageModel(image: image,
                                    color: .blackDay)
        return imageModel
    }
    
    func showRequestError() {
        let model = NetworkErrorViewModel(networkErrorImage:
                                            Resourses.Images.NetworkError.errorNetwork,
                                          notificationNetworkTitle: LocalizableConstants.NetworkErrorView.error) { [weak self] in
            guard let self else { return }
            self.resetState()
        }
        
        self.view?.showNetworkError(model: model)
    }
    
    func cleanData() {
        userLikes = []
        nftsInCart = []
        nftsModels = []
        detailsCollectionModel = nil
        user = nil
    }
    
    func resetState() {
        self.cleanData()
        self.view?.showLoadingIndicator()
        self.getNftAuthor()
        self.getNft(by: response.nfts ?? [])
        self.view?.hideNetworkError()
    }
    
    private func updateLikes(_ id: String) {
        guard var userLikes = userLikes else { return }
        if userLikes.contains(id) {
            userLikes.removeAll { $0 == id }
            self.userLikes = userLikes
        } else {
            userLikes.append(id)
            self.userLikes = userLikes
        }
    }
    
    private func updateCart(_ id: String) {
        guard var nftsInCart = nftsInCart else { return }
        if nftsInCart.contains(id) {
            nftsInCart.removeAll { $0 == id }
            self.nftsInCart = nftsInCart
        } else {
            nftsInCart.append(id)
            self.nftsInCart = nftsInCart
        }
    }
}
