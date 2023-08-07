import Foundation

protocol FavoritesNFTViewPresenterProtocol: AnyObject {
    var view: FavoritesNFTViewControllerProtocol? { get set }
    var favoritesNFTs: [NFT]? { get set }
}
