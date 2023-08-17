
import Foundation

extension DetailedCollectionPresenter {
    struct Services {
        let profileService: ProfileServiceProtocol
        let nftService: NftServiceProtocol
        let cartService: CartServiceProtocol
    }
}

final class DetailedCollectionPresenter {
    
    weak var view: DetailedCollectionViewProtocol?
    
    private let response: NftCollectionResponse
    private let services: Services
    private var nftsModels = [NFTCollectionViewCellViewModel]()
    private var detailsCollectionModel: CollectionDetailsTableViewCellModel?
    private var nftsInCart: Set<String> = []
    private var userLikes: Set<String> = []
    private var user: ProfileModel?
    private let group = DispatchGroup()
    
    init(response: NftCollectionResponse,
         services: Services) {
        self.response = response
        self.services = services
    }
}

extension DetailedCollectionPresenter: DetailedCollectionPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        getNftAuthor()
        getNft(by: response.nfts)
    }
    
    func viewDidAppear() {
        sendAnalytics(event: .open)
    }
    
    func viewDidDisappear() {
        sendAnalytics(event: .close)
    }
    
    func didTapOnLink(url: URL?) {
        guard let url else { return }
        let urlRequest = URLRequest(url: url)
        let presenter = WebViewPresenter(urlRequest: urlRequest)
        let vc = WebViewController(presenter: presenter)
        vc.hidesBottomBarWhenPushed = true
        presenter.view = vc
        view?.present(vc)
        sendAnalytics(event: .click, item: .authorWebsite)
    }
    
    func didTapCartButton(id: String) {

        if nftsInCart.contains(id) {
            nftsInCart.remove(id)
        } else {
            nftsInCart.insert(id)
        }
        
        self.nftsModels = self.nftsModels.compactMap { model in
            let isCartAdded = nftsInCart.contains(model.nftId)
            guard let imageModel = makeCartImageModel(isCartAdded: isCartAdded) else {
                return nil
            }
            let newModel = model.makeNewModel(cartButtonImageName: imageModel)
            return newModel
        }
        
        view?.updateNftsModel(with: nftsModels)
        
        putCartOrder(newCartModel: CartModel(nfts: Array(nftsInCart), id: "1"))
        
        sendAnalytics(event: .click, item: .addToCart)
    }
    
    func didTapLikeButton(id: String) {
        if userLikes.contains(id) {
            userLikes.remove(id)
        } else {
            userLikes.insert(id)
        }
        
        self.nftsModels = self.nftsModels.compactMap { model in
            let isFavorite = userLikes.contains(model.nftId)
            guard let imageModel = makeLikeImageModel(isFavorite: isFavorite) else {
                return nil
            }
            let newModel = model.makeNewModel(favoriteButtonImageName: imageModel)
            return newModel
        }

        view?.updateNftsModel(with: nftsModels)
        
        putFavorites()
        sendAnalytics(event: .click, item: .like)
    }
    
    func didChooseNft() {
        
    }
}

private extension DetailedCollectionPresenter {
    
    func getNftAuthor() {
        services.profileService.getProfile(id: "1") { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let user):
                self.user = user
                detailsCollectionModel = makeViewModel(user: user)
                guard let detailsCollectionModel else { return }
                view?.updateDetailsCollectionModel(with: detailsCollectionModel)
                self.view?.hideNetworkError()
            case .failure:
                showRequestError()
            }
        }
    }
    
    func getNft(by ids: [String]) {
        ids.forEach { id in
            group.enter()
            
            services.nftService.getNft(by: id) { [weak self] result in
                
                guard let self else { return }
                switch result {
                case .success(let response):
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
            self.getProfile(by: "1")
            self.getCartOrders()
            self.view?.hideLoadingIndicator()
        }
        
    }
    
    func getCartOrders() {
        services.cartService.getOrder(id: "1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cart):
                self.nftsInCart = Set(cart.nfts)
               
                self.nftsModels = self.nftsModels.compactMap { model in
                    let isCartAdded = self.nftsInCart.contains(model.nftId)
                    guard let imageModel = self.makeCartImageModel(isCartAdded: isCartAdded) else {
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
    
    func putCartOrder(newCartModel: CartModel) {
        services.cartService.putOrder(cart: newCartModel) { [weak self] result in
            switch result {
            case .success:
                self?.view?.hideNetworkError()
            case .failure:
                self?.showRequestError()
            }
        }
    }
    
    func putFavorites() {
        guard let user else { return }
        let profile = ProfileModel(name: user.name,
                                   avatar: user.avatar,
                                   description: user.description,
                                   website: user.website,
                                   nfts: user.nfts,
                                   likes: Array(userLikes),
                                   id: user.id)
        services.profileService.putProfile(user: profile) { [weak self] result in
            switch result {
            case .success:
                self?.view?.hideNetworkError()
            case .failure:
                self?.showRequestError()
            }
        }
    }
    
    func getProfile(by id: String) {
        services.profileService.getProfile(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.userLikes = Set(user.likes)
      
                self.nftsModels = self.nftsModels.compactMap { model in
                    let isFavorite = self.userLikes.contains(model.nftId)
                    guard let imageModel = self.makeLikeImageModel(isFavorite: isFavorite) else {
                        return nil
                    }
                    let newModel = model.makeNewModel(favoriteButtonImageName: imageModel)
                    return newModel
                }
                self.view?.updateNftsModel(with: nftsModels)
                self.view?.hideNetworkError()
            case .failure:
                showRequestError()
            }
        }
    }
    
    func makeViewModel(user: ProfileModel) -> CollectionDetailsTableViewCellModel {
        return CollectionDetailsTableViewCellModel(collectionId: response.id,
                                                   collectionDescription: response.description,
                                                   collectionName: response.name,
                                                   imageStringUrl: response.cover.makeUrl(),
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
        let model = NFTNetworkErrorViewModel(networkErrorImage:
                                                Resourses.Images.NetworkError.errorNetwork,
                                             notificationNetworkTitle: LocalizableConstants.NetworkErrorView.error) { [weak self] in
            guard let self else { return }
            self.cleanData()
            self.view?.showLoadingIndicator()
            self.getNftAuthor()
            self.getNft(by: response.nfts)
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
    
}


