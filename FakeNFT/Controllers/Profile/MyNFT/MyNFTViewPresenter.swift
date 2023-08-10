import Foundation

final class MyNFTViewPresenter: MyNFTViewPresenterProtocol {
    weak var view: MyNFTViewControllerProtocol?
    var profilePresenter: ProfileViewPresenterProtocol?
    private let nftService = NFTService.shared
    
    var purchasedNFTs: [NFT] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadViews()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    func fetchNFTs() {
        nftService.fetchNFT { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                guard let profile = profilePresenter?.profile else { return }
                self.purchasedNFTs = filterPurchasedNFTs(profile: profile, allNFTs: nfts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func arePurchasedNFTsEmpty() -> Bool {
        if purchasedNFTs.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    private func filterPurchasedNFTs(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        guard let profileNFTIds = profile.nfts else { return [] }

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id ?? "")
        }

        return filteredNFTs
    }
    
    func sortNFT(by: Sort) {
        var nfts = purchasedNFTs
        
        switch by {
        case .byPrice:
            nfts.sort { $0.price ?? 0.0 > $1.price ?? 0.0 }
        case .byRating:
            nfts.sort { $0.rating ?? 0 > $1.rating ?? 0 }
        case .byTitle:
            nfts.sort { $0.name ?? "" < $1.name ?? "" }
        default:
            break
        }
        
        self.purchasedNFTs = nfts
    }
}
