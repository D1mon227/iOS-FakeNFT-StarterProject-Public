import Foundation

final class CatalogPresenter {
    
    private let nftCatalogService: NftCatalogServiceProtocol
    private let downloadImageService: DownloadImageServiceProtocol
    private var viewModels: [CatalogTableViewCellViewModel] = []
    
    weak var view: CatalogViewProtocol?
    
    init(nftCatalogService: NftCatalogServiceProtocol,
         downloadImageService: DownloadImageServiceProtocol) {
        self.nftCatalogService = nftCatalogService
        self.downloadImageService = downloadImageService
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
        let byNameAction = AlertActionModel(title: "По названию",
                                           style: .default,
                                           titleTextColor: .systemBlue,
                                           handler: { [weak self] _ in
            
//             self?.sortByName()
        })
        
        let byCountAction = AlertActionModel(title: "По количеству NFT",
                                            style: .default,
                                            titleTextColor: .systemBlue,
                                            handler: { [weak self] _ in
             
//             self?.sortByCount()
         })
        
        let closeAction = AlertActionModel(title: "Закрыть",
                                            style: .cancel,
                                            titleTextColor: .systemBlue,
                                            handler: { [weak self] _ in
             
//             self?.sortByCount()
         })
        
        let model = AlertModel(title: "Сортировка",
                               message: nil,
                               actions: [byNameAction, byCountAction, closeAction],
                               preferredStyle: .actionSheet,
                               tintColor: .systemBlue)
        
        view?.displayAlert(model: model)

    }
    
    func didChooseSortingType(sortingType: SortingType) {
        
    }
}

private extension CatalogPresenter {
    func didGetNftItems(nftItems: [NftResponse]) {
        viewModels = nftItems.map { CatalogTableViewCellViewModel(nftResponse: $0) }// преобразование во вью модели
        
        view?.update(with: viewModels)
        downloadAndPresentImages()
    }
    
    func didGetError(error: Error) {
        
    }
    
    func downloadAndPresentImages() {
        viewModels.forEach { model in
            if model.imageData == nil,
               let encodedString = model.imageStringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedString) {
                downloadImageService.getDataFromUrl(url: url) { [weak self] data, response, error in
                    if let data,
                       error == nil {
                        self?.updateImage(id: model.id, data: data)
                    }
                    // обработка ошибок
                }
            }
        }
    }
    
    func updateImage(id: String, data: Data) {
        guard let viewModelIndex = viewModels.firstIndex(where: { $0.id == id }) else { return }
        var viewModel = viewModels[viewModelIndex]
        viewModel.imageData = data
        view?.updateImage(with: viewModel, at: viewModelIndex)
    }
}


