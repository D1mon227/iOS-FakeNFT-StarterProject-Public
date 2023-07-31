final class CatalogPresenter {
    
    private let nftCatalogService: NftCatalogServiceProtocol
    private var viewModels: [CatalogTableViewCellViewModel] = []
    
    weak var view: CatalogViewProtocol?
    
    init(nftCatalogService: NftCatalogServiceProtocol) {
        self.nftCatalogService = nftCatalogService
    }
}

extension CatalogPresenter: CatalogPresenterProtocol {
    func viewDidLoad() {
        nftCatalogService.getNftItems { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let items):
                self.didGetNftItems(nftItems: items)
            case  .failure(let error):
                self.didGetError(error: error)
            }
        }
    }
    
    func didTapSortingButton() {
        let firstAction = AlertActionModel(title: "По названию",
                                           style: .default,
                                           titleTextColor: .systemBlue,
                                           handler: { [weak self] _ in
            
//             self?.sortByName()
        })
        
        let secondAction = AlertActionModel(title: "По количеству NFT",
                                            style: .default,
                                            titleTextColor: .systemBlue,
                                            handler: { [weak self] _ in
             
//             self?.sortByCount()
         })
        let model = AlertModel(title: "Сортировка",
                               message: nil,
                               firstAction: firstAction,
                               secondAction: secondAction,
                               preferredStyle: .actionSheet,
                               tintColor: .systemBlue)
        
//        view?.displayAlert(model: model)

    }
    
    func didChooseSortingType(sortingType: SortingType) {
        
    }
}

private extension CatalogPresenter {
    func didGetNftItems(nftItems: [NftCodable]) {
//        viewModels = nftItems// преобразование во вью модели
        
//        view?.update(viewModels)
    }
    
    func didGetError(error: Error) {
        
    }
}

