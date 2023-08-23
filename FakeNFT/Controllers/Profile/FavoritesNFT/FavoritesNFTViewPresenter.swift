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
        favoritesNFTs.isEmpty ? true : false
    }
    
    func changeLike(_ id: String?) {
        guard let id = id else { return }
        removeLike(id)
		likeService.changeLike(newLike: Likes(likes: likes ?? [])) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newProfile):
                self.profilePresenter?.profile = newProfile
            case .failure(_):
                self.view?.showLikeErrorAlert(id: id)
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
            case .failure(_):
                self.view?.showNFTsErrorAlert()
            }
        }
    }
    
    private func removeLike(_ id: String?) {
        likes?.removeAll { $0 == id }
    }
    
    func getNFTsErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.fetchNFTs()
        }
        return model
    }
    
    func getLikeErrorModel(id: String) -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.traAgainMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.changeLike(id)
        }
        return model
    }
    
    private func filterFavoritesNFTs(profile: Profile, allNFTs: [NFT]) -> [NFT] {
        guard let profileNFTIds = profile.likes else { return [] }

        let filteredNFTs = allNFTs.filter { nft in
            return profileNFTIds.contains(nft.id ?? "")
        }

        return filteredNFTs
    }
}
