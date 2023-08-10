import Foundation

protocol MyNFTViewPresenterProtocol: AnyObject {
    var view: MyNFTViewControllerProtocol? { get set }
    var profilePresenter: ProfileViewPresenterProtocol? { get set }
    var purchasedNFTs: [NFT] { get set }
    func fetchNFTs()
    func arePurchasedNFTsEmpty() -> Bool
    func sortNFT(by: Sort)
}
