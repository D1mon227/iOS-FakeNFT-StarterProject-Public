import Foundation

final class FavoritesNFTViewPresenter: FavoritesNFTViewPresenterProtocol {
    weak var view: FavoritesNFTViewControllerProtocol?
    private var profilePresenter: ProfileViewPresenterProtocol?
    private let networkManager = NetworkManager()
    
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
    
    func changeLike(_ id: String) {
        removeLike(id)
        
        UIBlockingProgressHUD.show()
        let request = ProfileRequest(httpMethod: .put, dto: Likes(likes: self.likes ?? []))
        networkManager.send(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.view?.showLikeErrorAlert(id: id)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func fetchNFTs() {
        UIBlockingProgressHUD.show()
        let request = NFTsRequest(httpMethod: .get, dto: nil)
        networkManager.send(request: request, type: [NFT].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.favoritesNFTs = filterFavoritesNFTs(likes: likes ?? [], allNFTs: nfts)
            case .failure(_):
                self.view?.showNFTsErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func removeLike(_ id: String?) {
        likes?.removeAll { $0 == id }
    }
    
    func getNFTsErrorModel() -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.failedLoadDataMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.cancelButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.fetchNFTs()
        }
        return model
    }
    
    func getLikeErrorModel(id: String) -> AlertErrorModel {
        let model = AlertErrorModel(message: LocalizableConstants.Auth.Alert.traAgainMessage,
                                    leftButton: LocalizableConstants.Auth.Alert.okButton,
                                    rightButton: LocalizableConstants.Auth.Alert.tryAgainButton,
                                    numberOfButtons: 2) { [weak self] in
            guard let self = self else { return }
            self.changeLike(id)
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
