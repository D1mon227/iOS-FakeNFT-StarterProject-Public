import Foundation

protocol NFTCardViewPresenterProtocol: AnyObject {
    var view: NFTCardViewControllerProtocol? { get set }
    var nftModel: NFT? { get set }
    var isLiked: Bool? { get set }
    var currencies: [Currency]? { get }
    var nfts: [NFT]? { get set }
    func switchToNFTInformation(index: Int) -> WebViewController?
    func fetchData()
    func addNftToCard(_ id: String)
    func changeLike(_ id: String)
    func doesNftHaveLike(id: String?) -> Bool
    func isNftInCart(id: String?) -> Bool
    func getCurrencyErrorModel() -> AlertErrorModel
    func getNFTsErrorModel() -> AlertErrorModel
    func getProfileErrorModel() -> AlertErrorModel
    func getLikeErrorModel(id: String) -> AlertErrorModel
    func getCartErrorModel(id: String) -> AlertErrorModel
    func getNftCollectionErrorModel() -> AlertErrorModel
    func getNCartErrorModel() -> AlertErrorModel
}
