import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let nftService = NFTService.shared
    
    var purchasedNFTs: [NFT]?
    var favoritesNFTs: [NFT]?
    
    var profile: Profile? {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateProfileDetails(profile: self.profile)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
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
                guard let profile = profile else { return }
                self.purchasedNFTs = self.filterPurchasedNFTs(profile: profile, allNFTs: nfts)
                self.favoritesNFTs = self.filterFavoritesNFTs(profile: profile, allNFTs: nfts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func switchToAuthorInformation() -> WebViewController? {
        guard let website = profile?.website,
              let url = URL(string: website) else { return nil }
        let webViewPresenter = WebViewPresenter(urlRequest: URLRequest(url: url))
        let webViewController = WebViewController(presenter: webViewPresenter)
        webViewPresenter.view = webViewController
        
        return webViewController
    }
    
    private func filterPurchasedNFTs(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        let profileNFTIds = Set(profile.nfts)

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id)
        }

        return filteredNFTs
    }
    
    private func filterFavoritesNFTs(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        let profileNFTIds = Set(profile.likes)

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id)
        }

        return filteredNFTs
    }
}
