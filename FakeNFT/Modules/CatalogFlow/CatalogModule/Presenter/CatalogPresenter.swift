import Foundation

extension CatalogPresenter {
    
    struct KeyDefaults {
        static let sortingTypeCatalog = "sortingTypeCatalog"
    }
    
}

final class CatalogPresenter {
    
    private let nftCatalogService: NftCatalogServiceProtocol
    private var viewModels: [CatalogTableViewCellViewModel] = []
    private var responses: [NftCollectionResponse] = []
    
    weak var view: CatalogViewProtocol?
    
    init(nftCatalogService: NftCatalogServiceProtocol) {
        self.nftCatalogService = nftCatalogService
    }
}

extension CatalogPresenter: CatalogPresenterProtocol {
    func viewDidLoad() {
        view?.showLoadingIndicator()
        
        fetchNftItems()
        
    }
    
    func viewDidAppear() {
        sendAnalytics(event: .open)
    }
    
    func viewDidDisappear() {
        sendAnalytics(event: .close)
    }
    
    func didTapSortingButton() {
        let byNameAction = AlertActionModel(title: LocalizableConstants.Sort.byName,
                                            style: .default,
                                            titleTextColor: .systemBlue,
                                            handler: { [weak self] _ in
            guard let self else { return }
            self.sortByName()
            self.sendAnalytics(event: .click, item: .sortByName)
        })
        
        let byCountAction = AlertActionModel(title: LocalizableConstants.Sort.byNFTQuantity,
                                             style: .default,
                                             titleTextColor: .systemBlue,
                                             handler: { [weak self] _ in
            guard let self else { return }
            self.sortByCount()
            self.sendAnalytics(event: .click, item: .sortByNFTQuantity)
        })
        
        let closeAction = AlertActionModel(title: LocalizableConstants.Sort.close,
                                           style: .cancel,
                                           titleTextColor: .systemBlue,
                                           handler: nil)
        
        let model = AlertModel(title: LocalizableConstants.Sort.sort,
                               message: nil,
                               actions: [byNameAction, byCountAction, closeAction],
                               preferredStyle: .actionSheet,
                               tintColor: .systemBlue)
        
        view?.displayAlert(model: model)
        
    }
    
    func didSelectCell(with id: String) {
        guard let response = responses.first(where: { $0.id == id }) else {
            return
        }
        
        let viewController = CatalogModulesFactory.makeDetailedCollectionModule(response: response)
        view?.push(viewController)
        
        sendAnalytics(event: .click, item: .nftCollection)
    }
    
}

private extension CatalogPresenter {
    
    func sortByCount() {
        viewModels.sort(by: { $0.nftCount > $1.nftCount })
        view?.update(with: viewModels)
        saveSortingType(.byCount)
    }
    
    func sortByName() {
        viewModels.sort(by: { $0.nftName < $1.nftName })
        view?.update(with: viewModels)
        saveSortingType(.byName)
    }
    
    func fetchNftItems() {
        nftCatalogService.getNftItems { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let items):
                responses = items
                self.didGetNftItems(nftItems: items)
            case  .failure:
                self.showRequestError()
            }
            self.view?.hideLoadingIndicator()
        }
    }
    
    func saveSortingType(_ sortingType: SortingType) {
        UserDefaults.standard.set(sortingType.rawValue, forKey: KeyDefaults.sortingTypeCatalog)
    }
    
    func didGetNftItems(nftItems: [NftCollectionResponse]) {
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
    
    func showRequestError() {
        let requestErrorModel = NetworkErrorViewModel(networkErrorImage: Resourses.Images.NetworkError.errorNetwork,
                                                      notificationNetworkTitle: LocalizableConstants.NetworkErrorView.error) { [weak self] in
            self?.viewModels = []
            self?.responses = []
            
            self?.view?.showLoadingIndicator()
            self?.fetchNftItems()
        }
    }
    
    func sendAnalytics(event: Event, item: Item? = nil) {
        AnalyticsService.shared.report(event: event,
                                       screen: .catalogVC,
                                       item: item)
    }
    
}



