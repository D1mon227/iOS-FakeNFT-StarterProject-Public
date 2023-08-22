import Foundation

protocol MyNFTViewPresenterProtocol: AnyObject {
    var view: MyNFTViewControllerProtocol? { get set }
    var profilePresenter: ProfileViewPresenterProtocol? { get set }
    var purchasedNFTs: [NFT] { get set }
    var likes: [String]? { get set }
    var users: [User] { get }
    func fetchNFTs()
    func fetchUsers()
    func changeLike(_ id: String)
    func doesNftHasLike(id: String?) -> Bool
    func getAuthorName(for authorID: String, from authors: [User]) -> String?
    func arePurchasedNFTsEmpty() -> Bool
    func sortNFT(by: Sort)
    func getSortModel() -> AlertSortModel
    func getUsersErrorModel() -> AlertErrorModel
    func getNFTsErrorModel() -> AlertErrorModel
    func getLikeErrorModel(id: String) -> AlertErrorModel
}
