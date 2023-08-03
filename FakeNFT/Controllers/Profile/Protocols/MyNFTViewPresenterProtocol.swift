import Foundation

protocol MyNFTViewPresenterProtocol: AnyObject {
    var view: MyNFTViewControllerProtocol? { get set }
    var nfts: [NFT]? { get set }
    func fetchNFTs()
}
