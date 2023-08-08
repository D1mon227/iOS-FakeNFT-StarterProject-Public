import Foundation

final class MyNFTViewPresenter: MyNFTViewPresenterProtocol {
    weak var view: MyNFTViewControllerProtocol?
    var profilePresenter: ProfileViewPresenterProtocol?
    
    var purchasedNFTs: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
        }
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    func getPurchasedNFTs() {
        guard let profile = profilePresenter?.profile,
              let allNFTs = profilePresenter?.allNFTs else { return }
        purchasedNFTs = filterPurchasedNFTs(profile: profile, allNFTs: allNFTs)
    }
    
    private func filterPurchasedNFTs(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        let profileNFTIds = Set(profile.nfts)

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id)
        }

        return filteredNFTs
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
