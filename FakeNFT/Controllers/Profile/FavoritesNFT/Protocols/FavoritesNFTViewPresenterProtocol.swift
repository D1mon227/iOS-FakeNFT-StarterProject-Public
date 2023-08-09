import Foundation

protocol FavoritesNFTViewPresenterProtocol: AnyObject {
    var view: FavoritesNFTViewControllerProtocol? { get set }
    var favoritesNFTs: [NFT] { get set }
    var likes: [String]? { get set }
    func getFavoritesNFTs()
    func areFavoritesNFTsEmpty() -> Bool
    func changeLike(_ id: String?)
}
