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
    func fetchProfile()
    func fetchNFTCollections()
    func changeLike(_ id: String)
    func doesNftHasLike(id: String?) -> Bool
    func getCurrencyErrorModel() -> AlertErrorModel
    func getNFTsErrorModel() -> AlertErrorModel
    func getErrorModel() -> AlertErrorModel
    func getLikeErrorModel(id: String) -> AlertErrorModel
}
