
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
        
        view?.hideLoadingIndicator()
    }
    
    func didTapOnLink(url: URL?) {
        guard let url else { return }
        let urlRequest = URLRequest(url: url)
        let presenter = WebViewPresenter(urlRequest: urlRequest)
        let vc = WebViewController(presenter: presenter)
        vc.hidesBottomBarWhenPushed = true
        presenter.view = vc
        view?.present(vc)
    }
    
    func didTapCartButton(id: String) {

        if nftsInCart.contains(id) {
            nftsInCart.remove(id)
        } else {
            nftsInCart.insert(id)
        }
        
        self.nftsModels = self.nftsModels.map { model in
            let newModel = model.makeNewModel(isCartAdded: nftsInCart.contains(model.nftId))
            return newModel
        }
        
        view?.updateNftsModel(with: nftsModels)
        
        putCartOrder(newCartModel: CartModel(nfts: Array(nftsInCart), id: "1"))
    }
    
    func didTapLikeButton(id: String) {
        if userLikes.contains(id) {
            userLikes.remove(id)
        } else {
            userLikes.insert(id)
        }
        
        self.nftsModels = self.nftsModels.map { model in
            let newModel = model.makeNewModel(isFavorite: userLikes.contains(model.nftId))
            return newModel
        }

        view?.updateNftsModel(with: nftsModels)
        
        putFavorites()
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
            case .failure(let error): print("error getNftAuthor", error)
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
                    
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.getProfile(by: "1")
            self?.getCartOrders()
        }
        
    }
    
    func getCartOrders() {
        services.cartService.getOrder(id: "1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cart):
                self.nftsInCart = Set(cart.nfts)
               
                self.nftsModels = self.nftsModels.map { model in
                    let newModel = model.makeNewModel(isCartAdded: self.nftsInCart.contains(model.nftId))
                    return newModel
                }

                view?.updateNftsModel(with: nftsModels)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func putCartOrder(newCartModel: CartModel) {
        services.cartService.putOrder(cart: newCartModel) { result in
            switch result {
            case .success: break
            case .failure(let error):
                print(error)
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
        services.profileService.putProfile(user: profile) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
               print("error", error)
            }
        }
    }
    
    func getProfile(by id: String) {
        services.profileService.getProfile(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                userLikes = Set(user.likes)
      
                self.nftsModels = self.nftsModels.map { model in
                    let newModel = model.makeNewModel(isFavorite: self.userLikes.contains(model.nftId))
                    return newModel
                }
                view?.updateNftsModel(with: nftsModels)
            case .failure(let error):
                print(error)
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
    
}


