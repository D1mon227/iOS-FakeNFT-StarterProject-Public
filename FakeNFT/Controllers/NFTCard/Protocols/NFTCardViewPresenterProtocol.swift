import Foundation

protocol NFTCardViewPresenterProtocol: AnyObject {
    var view: NFTCardViewControllerProtocol? { get set }
    var nftModel: NFT? { get set }
    var isLiked: Bool? { get set }
}
