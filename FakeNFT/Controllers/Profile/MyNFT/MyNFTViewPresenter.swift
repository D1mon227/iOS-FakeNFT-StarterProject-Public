import Foundation

final class MyNFTViewPresenter: MyNFTViewPresenterProtocol {
    weak var view: MyNFTViewControllerProtocol?
    
    var purchasedNFTs: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        }
    }
    
    func sortNFT(by: Sort) {
        guard var nfts = purchasedNFTs else { return }
        
        switch by {
        case .byPrice:
            nfts.sort { $0.price > $1.price }
        case .byRating:
            nfts.sort { $0.rating > $1.rating }
        case .byTitle:
            nfts.sort { $0.name < $1.name }
        default:
            break
        }
        
        self.purchasedNFTs = nfts
    }
}
