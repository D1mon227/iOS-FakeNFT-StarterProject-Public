import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    var profile: Profile? { get set }
    var allNFTs: [NFT]? { get }
    func fetchProfile()
    func fetchNFTs()
    func switchToAuthorInformation() -> WebViewController?
}
