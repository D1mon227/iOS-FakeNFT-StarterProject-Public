import Foundation

final class FavoritesNFTViewPresenter: FavoritesNFTViewPresenterProtocol {
    weak var view: FavoritesNFTViewControllerProtocol?
    private var profilePresenter: ProfileViewPresenterProtocol?
    private let likeService = LikeService.shared
    private let nftService = NFTService.shared
    
    var likes: [String]?
    var favoritesNFTs: [NFT] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadViews()
            }
        }
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    func areFavoritesNFTsEmpty() -> Bool {
        if favoritesNFTs.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func changeLike(_ id: String?) {
        guard let id = id else { return }
        removeLike(id)
        likeService.changeLike(newLike: Like(likes: likes)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newProfile):
                self.profilePresenter?.profile = newProfile
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
                guard let profile = profilePresenter?.profile else { return }
                self.favoritesNFTs = filterFavoritesNFTs(profile: profile, allNFTs: nfts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func removeLike(_ id: String?) {
        likes?.removeAll { $0 == id }
    }
    
    private func filterFavoritesNFTs(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        guard let profileNFTIds = profile.likes else { return [] }

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id ?? "")
        }

        return filteredNFTs
    }
}
