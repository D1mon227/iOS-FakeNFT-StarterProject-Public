import Foundation

protocol FavoritesNFTViewPresenterProtocol: AnyObject {
    var view: FavoritesNFTViewControllerProtocol? { get set }
    var nfts: [NFT]? { get set }
}
