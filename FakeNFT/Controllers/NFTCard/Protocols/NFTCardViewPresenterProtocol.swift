import Foundation

protocol NFTCardViewPresenterProtocol: AnyObject {
    var view: NFTCardViewControllerProtocol? { get set }
    var nftModel: NFT? { get set }
    var isLiked: Bool? { get set }
    var currencies: [Currency]? { get }
    var nfts: [NFT]? { get set }
    func fetchCurrencies()
    func switchToNFTInformation(index: Int) -> WebViewController?
    func fetchNFTs()
    func getCurrencyErrorModel() -> AlertErrorModel
    func getNFTsErrorModel() -> AlertErrorModel
}
