import Foundation

final class FavoritesNFTViewPresenter: FavoritesNFTViewPresenterProtocol {
    weak var view: FavoritesNFTViewControllerProtocol?
    private var profilePresenter: ProfileViewPresenterProtocol?
    private let likeService = LikeService.shared
    
    var likes: [String]?
    var favoritesNFTs: [NFT]? {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadCollectionView()
            }
        }
    }
    
    init(profilePresenter: ProfileViewPresenterProtocol?) {
        self.profilePresenter = profilePresenter
    }
    
    func changeLike(_ id: String?) {
        guard let nfts = profilePresenter?.allNFTs,
              let id = id else { return }
        removeLike(id)
        likeService.changeLike(newLike: Like(likes: likes)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newProfile):
                self.profilePresenter?.profile = newProfile
                self.favoritesNFTs = filterFavoritesNFTs(profile: newProfile, allNFTs: nfts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getFavoritesNFTs() {
        guard let profile = profilePresenter?.profile,
              let allNFTs = profilePresenter?.allNFTs else { return }
        favoritesNFTs = filterFavoritesNFTs(profile: profile, allNFTs: allNFTs)
    }
    
    private func removeLike(_ id: String?) {
        likes?.removeAll { $0 == id }
    }
    
    private func filterFavoritesNFTs(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        let profileNFTIds = Set(profile.likes)

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id)
        }

        return filteredNFTs
    }
}
