
import Foundation

final class DetailedCollectionPresenter {
    weak var view: DetailedCollectionViewProtocol?
    
    private let response: NftCollectionResponse
    private let authorService: NFTAuthorServiceProtocol
    private let nftService: NftServiceProtocol
    private var nftsModels = [NFTCollectionViewCellModel]()
    private let group = DispatchGroup()
    
    init(response: NftCollectionResponse,
         authorService: NFTAuthorServiceProtocol,
         nftService: NftServiceProtocol) {
        self.response = response
        self.authorService = authorService
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
        authorService.getNftAuthor(by: response.author) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let author):
                let detailedCollectionViewModel = makeViewModel(author: author)
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
                    let viewModel = self.makeViewModel(nftResponse: response)
                    self.nftsModels.append(viewModel)
                    
                case .failure(let error): break
                    print(error)
                }
                
                group.leave()
                
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            print(self.nftsModels, self.nftsModels.count == ids.count)
        }
        
    }
    
    func makeViewModel(author: AuthorResponse) -> NFTCollectionTableViewCellModel {
        return NFTCollectionTableViewCellModel(collectionId: response.id,
                                               authorResponse: author,
                                               collectionDescription: response.description,
                                               collectionName: response.name)
        
    }
    
    func makeViewModel(nftResponse: NftResponse) -> NFTCollectionViewCellViewModel {
        NFTCollectionViewCellViewModel(nftResponse: nftResponse)
    }

}
