
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
    private var cartModel: CartModel?
    private var userLikes: Set<String> = []
    private var user: ProfileModel?
    private var viewModels: [DetailedCollectionTableViewCellProtocol] = []
    private let group = DispatchGroup()
    
    init(response: NftCollectionResponse,
         services: Services) {
        self.response = response
        self.services = services
    }
}

extension DetailedCollectionPresenter: DetailedCollectionPresenterProtocol {
    
    func viewDidLoad() {
        getNftAuthor()
        getNft(by: response.nfts)
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
        guard let cartModel else { return }
        var newCartModel: CartModel
        if cartModel.nfts.contains(id) {
            let nfts = cartModel.nfts.filter { $0 != id }
            newCartModel = CartModel(nfts: nfts, id: cartModel.id)
            self.cartModel = newCartModel
        } else {
          
            newCartModel = CartModel(nfts: cartModel.nfts + [id], id: cartModel.id)
            self.cartModel = newCartModel
        }
        
        self.nftsModels = self.nftsModels.map { model in
            let newModel = model.makeNewModel(isCartAdded: cartModel.nfts.contains(model.nftId))
            print(cartModel.nfts.contains(model.nftId))
            return newModel
        }
        
        let viewModel = NFTCollectionTableViewCellViewModel(nftModels: self.nftsModels)
        if viewModels.count > 1 {
            viewModels[1] = viewModel
        } else {
            viewModels.append(viewModel)
        }
        view?.updateViewModel(with: viewModels)
        
        
        putCartOrder(newCartModel: newCartModel)
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
        
        let viewModel = NFTCollectionTableViewCellViewModel(nftModels: self.nftsModels)
        if viewModels.count > 1 {
            viewModels[1] = viewModel
        } else {
            viewModels.append(viewModel)
        }
        view?.updateViewModel(with: viewModels)
        
        
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
                let detailedCollectionViewModel = makeViewModel(user: user)
                viewModels.insert(detailedCollectionViewModel, at: 0)
                view?.updateViewModel(with: viewModels)
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
                self.cartModel = cart
                let set = Set(cart.nfts)
                self.nftsModels = self.nftsModels.map { model in
                    let newModel = model.makeNewModel(isCartAdded: set.contains(model.nftId))
                    print(set.contains(model.nftId))
                    return newModel
                }
                let viewModel = NFTCollectionTableViewCellViewModel(nftModels: self.nftsModels)
                if viewModels.count > 1 {
                    viewModels[1] = viewModel
                } else {
                    viewModels.append(viewModel)
                }
                view?.updateViewModel(with: viewModels)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func putCartOrder(newCartModel: CartModel) {
        
        services.cartService.putOrder(cart: newCartModel) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cart):
                let set = Set(cart.nfts)
                self.nftsModels = self.nftsModels.map { model in
                    let newModel = model.makeNewModel(isCartAdded: set.contains(model.nftId))
                    print(set.contains(model.nftId))
                    return newModel
                }
                let viewModel = NFTCollectionTableViewCellViewModel(nftModels: self.nftsModels)
                if viewModels.count > 1 {
                    viewModels[1] = viewModel
                } else {
                    viewModels.append(viewModel)
                }
                view?.updateViewModel(with: viewModels)
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
        services.profileService.putProfile(user: profile) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                print("putFavorites success")
                break
            case .failure(let error):
                if let error = error as? NetworkError {
                    switch error {
                    case .codeError(let statusCode):
                        print("putFavorites error", statusCode)
                    }
                    
                }
                
            }
        }
    }
    
    func getProfile(by id: String) {
        services.profileService.getProfile(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                userLikes = Set(user.likes)
                let set = Set(user.likes)
                self.nftsModels = self.nftsModels.map { model in
                    let newModel = model.makeNewModel(isFavorite: set.contains(model.nftId))
                    return newModel
                }
                let viewModel = NFTCollectionTableViewCellViewModel(nftModels: self.nftsModels)
                if viewModels.count > 1 {
                    viewModels[1] = viewModel
                } else {
                    viewModels.append(viewModel)
                }
                view?.updateViewModel(with: viewModels)
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

