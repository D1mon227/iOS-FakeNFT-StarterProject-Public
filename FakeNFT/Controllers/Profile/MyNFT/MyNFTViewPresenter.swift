import Foundation

final class MyNFTViewPresenter: MyNFTViewPresenterProtocol {
    var view: MyNFTViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profilePresenter: ProfileViewPresenterProtocol?
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    var nfts: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadTableView()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func fetchNFTs() {
        guard let profile = self.profilePresenter?.profile else { return }
        
        profileService.fetchNFT { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = self.filterNFTsForProfile(profile: profile, allNFTs: nfts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func filterNFTsForProfile(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        let profileNFTIds = Set(profile.nfts)

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id)
        }

        return filteredNFTs
    }
}
