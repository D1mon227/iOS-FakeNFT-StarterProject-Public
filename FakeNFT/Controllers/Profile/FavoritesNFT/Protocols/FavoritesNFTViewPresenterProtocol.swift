import Foundation

protocol FavoritesNFTViewPresenterProtocol: AnyObject {
    var view: FavoritesNFTViewControllerProtocol? { get set }
    var favoritesNFTs: [NFT] { get set }
    var likes: [String]? { get set }
    func fetchNFTs()
    func fetchProfile()
    func areFavoritesNFTsEmpty() -> Bool
    func changeLike(_ id: String?)
    func getNFTsErrorModel() -> AlertErrorModel
    func getErrorModel() -> AlertErrorModel
    func getLikeErrorModel(id: String) -> AlertErrorModel
}
