import Foundation

final class NFTCardViewPresenter: NFTCardViewPresenterProtocol {
    weak var view: NFTCardViewControllerProtocol?
    private let currencyService = CurrencyService.shared
    private let nftService = NFTService.shared
    
    var nftModel: NFT?
    var isLiked: Bool?
    
    var currencies: [Currency]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        }
    }
    
    var nfts: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadCollectionView()
            }
        }
    }
    
    private var NFTUrls = [
        Resourses.Network.NFTUrls.bitcoin, Resourses.Network.NFTUrls.dogecoin,
        Resourses.Network.NFTUrls.tether, Resourses.Network.NFTUrls.apecoin,
        Resourses.Network.NFTUrls.solana, Resourses.Network.NFTUrls.ethereum,
        Resourses.Network.NFTUrls.cardano, Resourses.Network.NFTUrls.shibainu
    ]
    
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
    
    func fetchNFTs() {
        nftService.fetchNFT { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                let randomIndexes = generateRandomNFTsIndexes(max: nfts.count, count: 5)
                self.nfts = randomIndexes.map { nfts[$0]}
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func switchToNFTInformation(index: Int) -> WebViewController? {
        guard let url = URL(string: NFTUrls[index]) else { return nil }
        let webViewPresenter = WebViewPresenter(urlRequest: URLRequest(url: url))
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        
        return webViewController
    }
    
    private func generateRandomNFTsIndexes(max: Int, count: Int) -> [Int] {
        guard max >= count else {
            fatalError("max must be greater than or equal to count")
        }
        var randomIndexes: Set<Int> = []
        
        while randomIndexes.count < count {
            let randomIndex = Int.random(in: 0..<max)
            randomIndexes.insert(randomIndex)
        }
        
        return Array(randomIndexes)
    }
}
