import Foundation

extension CatalogPresenter {
    
    struct KeyDefaults {
        static let sortingTypeCatalog = "sortingTypeCatalog"
    }
    
}

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
        view?.showLoadingIndicator()
        
        nftCatalogService.getNftItems { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let items):
                self.didGetNftItems(nftItems: items)
            case  .failure(let error):
                self.didGetError(error: error)
            }
            self.view?.hideLoadingIndicator()
        }
    }
    
    func didTapSortingButton() {
        let byNameAction = AlertActionModel(title: "По названию",
                                            style: .default,
                                            titleTextColor: .systemBlue,
                                            handler: { [weak self] _ in
            
            self?.sortByName()
        })
        
        let byCountAction = AlertActionModel(title: "По количеству NFT",
                                             style: .default,
                                             titleTextColor: .systemBlue,
                                             handler: { [weak self] _ in
            
            self?.sortByCount()
        })
        
        let closeAction = AlertActionModel(title: "Закрыть",
                                           style: .cancel,
                                           titleTextColor: .systemBlue,
                                           handler: { [weak self] _ in
            
            self?.sortByCount()
        })
        
        let model = AlertModel(title: "Сортировка",
                               message: nil,
                               actions: [byNameAction, byCountAction, closeAction],
                               preferredStyle: .actionSheet,
                               tintColor: .systemBlue)
        
        view?.displayAlert(model: model)
        
    }
    
}

private extension CatalogPresenter {
    
    func sortByCount() {
        //userDefaults
        viewModels.sort(by: { $0.nftCount > $1.nftCount })
        view?.update(with: viewModels)
        saveSortingType(.byCount)
    }
    
    func sortByName() {
        //userDefaults
        viewModels.sort(by: { $0.nftName < $1.nftName })
        view?.update(with: viewModels)
        saveSortingType(.byName)
    }
    
    func saveSortingType(_ sortingType: SortingType) {
        UserDefaults.standard.set(sortingType.rawValue, forKey: KeyDefaults.sortingTypeCatalog)
    }
    
    func didGetNftItems(nftItems: [NftResponse]) {
            viewModels = nftItems.map { CatalogTableViewCellViewModel(nftResponse: $0) }
    
            if let sortingTypeString = UserDefaults.standard.string(forKey: KeyDefaults.sortingTypeCatalog),
               let sortingType = SortingType(rawValue: sortingTypeString) {
                switch sortingType {
                case .byCount: sortByCount()
                case .byName: sortByName()
                }
            } else {
                view?.update(with: viewModels)
            }
        }
    
    func didGetError(error: Error) {
        
    }
    
}



