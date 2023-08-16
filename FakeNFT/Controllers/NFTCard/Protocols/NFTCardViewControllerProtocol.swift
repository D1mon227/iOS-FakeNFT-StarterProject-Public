import Foundation

protocol NFTCardViewControllerProtocol: AnyObject {
    var presenter: NFTCardViewPresenterProtocol? { get set }
    func updateNFTDetails(nftModel: NFT?)
    func updateLikeButton(isLiked: Bool)
    func reloadTableView()
}
