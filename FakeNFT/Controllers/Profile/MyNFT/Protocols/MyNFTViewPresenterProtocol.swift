import Foundation

protocol MyNFTViewPresenterProtocol: AnyObject {
    var view: MyNFTViewControllerProtocol? { get set }
    var purchasedNFTs: [NFT]? { get set }
//    func fetchNFTs()
//    func filterPurchasedNFTs(profile: Profile, allNFTs: [NFT])
    func sortNFT(by: Sort)
}
