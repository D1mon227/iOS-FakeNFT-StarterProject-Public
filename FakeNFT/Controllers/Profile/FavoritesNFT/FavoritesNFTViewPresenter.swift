import Foundation

final class FavoritesNFTViewPresenter: FavoritesNFTViewPresenterProtocol {
    weak var view: FavoritesNFTViewControllerProtocol?
    private let likeService = LikeService.shared
    private let nftService = NFTService.shared
    private let profileService = ProfileService.shared
    
    var likes: [String]?
    var favoritesNFTs: [NFT] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadViews()
            }
        }
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
            case .success(_):
                break
            case .failure(_):
                self.view?.showLikeErrorAlert(id: id)
            }
        }
    }
    
    func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.likes = profile.likes
            case .failure(_):
                self.view?.showErrorAlert()
            }
        }
    }
    
    func fetchNFTs() {
        nftService.fetchNFT { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.favoritesNFTs = filterFavoritesNFTs(likes: likes ?? [], allNFTs: nfts)
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
    
    func getErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    buttonText: LocalizableConstants.Auth.Alert.tryAgainButton) { [weak self] in
            guard let self = self else { return }
            self.fetchProfile()
        }
        return model
    }
    
    private func filterFavoritesNFTs(likes: [String], allNFTs: [NFT]) -> [NFT] {
        let filteredNFTs = allNFTs.filter { nft in
            return likes.contains(nft.id ?? "")
        }

        return filteredNFTs
    }
}
