
import Foundation

final class DetailedCollectionPresenter {
    
    weak var view: DetailedCollectionViewProtocol?
    
    private let response: NftCollectionResponse
    private let profileService: ProfileServiceProtocol
    private let nftService: NftServiceProtocol
    private var nftsModels = [NFTCollectionViewCellViewModel]()
    private let group = DispatchGroup()
    
    init(response: NftCollectionResponse,
         profileService: ProfileServiceProtocol,
         nftService: NftServiceProtocol) {
        self.response = response
        self.profileService = profileService
        self.nftService = nftService
    }
}

extension DetailedCollectionPresenter: DetailedCollectionPresenterProtocol {
    
    func viewDidLoad() {
        getNftAuthor()
        getNft(by: response.nfts)
    }
}

private extension DetailedCollectionPresenter {
    
    func getNftAuthor() {
        profileService.getProfile(id: response.author) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                let detailedCollectionViewModel = makeViewModel(user: user)
                view?.updateViewModel(with: detailedCollectionViewModel)
            case .failure(let error): break
            }
        }
    }
    
    func getNft(by ids: [String]) {
        ids.forEach { id in
            group.enter()
            
            nftService.getNft(by: id) { [weak self] result in
                
                guard let self else { return }
                switch result {
                case .success(let response):
                    let viewModel = NFTCollectionViewCellViewModel(nftResponse: response)
                    self.nftsModels.append(viewModel)
                    
                case .failure(let error): break
                    print(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.getProfile(by: "1")
        }
        
    }
    
    func getProfile(by id: String) {
        profileService.getProfile(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                let set = Set(user.likes)
                self.nftsModels = self.nftsModels.map { model in
                    var newModel = model.makeNewModel(isFavorite: set.contains(model.nftId))
                    return newModel
                }
                let viewModel = NFTCollectionTableViewCellViewModel(nftModels: self.nftsModels)
                self.view?.updateViewModel(with: viewModel)
            case .failure(let error): break
            }
        }
    }
    
    func makeViewModel(user: ProfileModel) -> CollectionDetailsTableViewCellModel {
        return CollectionDetailsTableViewCellModel(collectionId: response.id,
                                                   user: user,
                                                   collectionDescription: response.description,
                                                   collectionName: response.name)
        
    }

}

