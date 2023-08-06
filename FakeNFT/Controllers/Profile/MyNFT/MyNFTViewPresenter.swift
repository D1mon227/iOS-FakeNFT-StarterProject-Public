import Foundation

final class MyNFTViewPresenter: MyNFTViewPresenterProtocol {
    weak var view: MyNFTViewControllerProtocol?
    private let nftService = NFTService.shared
    private var profilePresenter: ProfileViewPresenterProtocol?
    
    var nfts: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    func fetchNFTs() {
        guard let profile = self.profilePresenter?.profile else { return }
        
        nftService.fetchNFT { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = self.filterNFTsForProfile(profile: profile, allNFTs: nfts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func filterNFTsForProfile(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        let profileNFTIds = Set(profile.nfts)

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id)
        }

        return filteredNFTs
    }
    
    func sortNFT(by: Sort) {
        guard var nfts = nfts else { return }
        
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
        
        self.nfts = nfts
    }
}
