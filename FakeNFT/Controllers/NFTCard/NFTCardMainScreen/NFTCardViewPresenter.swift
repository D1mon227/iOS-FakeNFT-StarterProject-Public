import Foundation

final class NFTCardViewPresenter: NFTCardViewPresenterProtocol {
    weak var view: NFTCardViewControllerProtocol?
    private let currencyService = CurrencyService.shared
    
    var nftModel: NFT?
    var isLiked: Bool?
    
    var currencies: [Currency]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func fetchCurrencies() {
        currencyService.fetchCurrencies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencies):
                self.currencies = currencies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
