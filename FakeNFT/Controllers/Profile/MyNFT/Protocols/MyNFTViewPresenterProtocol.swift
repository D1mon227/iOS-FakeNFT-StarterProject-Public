import Foundation

protocol MyNFTViewPresenterProtocol: AnyObject {
    var view: MyNFTViewControllerProtocol? { get set }
    var profilePresenter: ProfileViewPresenterProtocol? { get set }
    var purchasedNFTs: [NFT] { get set }
    var users: [User] { get }
    func fetchNFTs()
    func fetchUsers()
    func getAuthorName(for authorID: String, from authors: [User]) -> String?
    func arePurchasedNFTsEmpty() -> Bool
    func sortNFT(by: Sort)
}
