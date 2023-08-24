import Foundation

final class CartPresenter: CartPresenterProtocol {
    weak var view: CartViewControllerProtocol?
    private let networkManager = NetworkManager()
    private var order: [String]?
    private let sortUserDefaultsKey = "SortCart"
    
    var nfts: [NFT] = [] {
        didSet {
            self.view?.reloadViews()
        }
    }
    
    private var currentSort: Sort {
        get {
            if let savedSort = UserDefaults.standard.string(forKey: sortUserDefaultsKey) {
                return Sort(rawValue: savedSort) ?? .byRating
            } else {
                return .byRating
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: sortUserDefaultsKey)
        }
    }
    
    func cartNFTs() {
        UIBlockingProgressHUD.show()
        let request = CartGetRequest()
        networkManager.send(request: request, type: Order.self) { [weak self] result  in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = order.nfts
                self.getNFTsFromAPI()
            case .failure(let error):
                print(error.localizedDescription)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func getNFTsFromAPI() {
        UIBlockingProgressHUD.show()
        let request = NFTsGetRequest()
        networkManager.send(request: request, type: [NFT].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = filterOrderedNFTs(order: self.order ?? [], allNFTs: nfts)
                self.sortNFT(by: currentSort)
            case .failure(let error):
                print(error.localizedDescription)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func deleteFromCart(id: String) {
        updateCart(id)
        UIBlockingProgressHUD.show()
        let request = CartPutRequest(dto: Order(nfts: self.order ?? [], id: "1"))
        networkManager.send(request: request, type: Order.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newOrder):
                self.nfts = filterOrderedNFTs(order: newOrder.nfts, allNFTs: nfts)
            case .failure(let error):
                print(error.localizedDescription)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func sortNFT(by: Sort) {
        var nfts = nfts
        
        switch by {
        case .byPrice:
            nfts.sort { $0.price ?? 0.0 > $1.price ?? 0.0 }
            currentSort = .byPrice
        case .byRating:
            nfts.sort { $0.rating ?? 0 > $1.rating ?? 0 }
            currentSort = .byRating
        case .byTitle:
            nfts.sort { $0.name ?? "" < $1.name ?? "" }
            currentSort = .byTitle
        default:
            break
        }
        
        self.nfts = nfts
    }
    
    func areOrderIsEmpty() -> Bool {
        nfts.isEmpty ? true : false
    }
    
    func getSortModel() -> AlertSortModel {
        let sortingOptions: [Sort] = [.byPrice, .byRating, .byTitle, .close]
        let model = AlertSortModel(actions: sortingOptions) { [weak self] option in
            guard let self = self else { return }
            self.sortNFT(by: option)
        }
        return model
    }
    
    private func filterOrderedNFTs(order: [String], allNFTs: [NFT]) -> [NFT] {
        let filteredNFTs = allNFTs.filter { nft in
            return order.contains(nft.id ?? "")
        }

        return filteredNFTs
    }
    
    private func updateCart(_ id: String?) {
        order?.removeAll { $0 == id }
    }
}
