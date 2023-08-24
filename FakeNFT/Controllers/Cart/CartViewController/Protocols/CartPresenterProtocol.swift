import Foundation

protocol CartPresenterProtocol: AnyObject {
    var view: CartViewControllerProtocol? { get set }
    var nfts: [NFT] { get set }
    func cartNFTs()
    func getNFTsFromAPI()
    func deleteFromCart(id: String)
    func areOrderIsEmpty() -> Bool
    func getSortModel() -> AlertSortModel
}
