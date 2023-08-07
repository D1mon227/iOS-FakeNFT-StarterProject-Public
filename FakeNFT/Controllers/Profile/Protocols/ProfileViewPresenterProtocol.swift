import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var profile: Profile? { get set }
    var purchasedNFTs: [NFT]? { get set }
    var favoritesNFTs: [NFT]? { get set }
    func fetchProfile()
    func fetchNFTs()
}
