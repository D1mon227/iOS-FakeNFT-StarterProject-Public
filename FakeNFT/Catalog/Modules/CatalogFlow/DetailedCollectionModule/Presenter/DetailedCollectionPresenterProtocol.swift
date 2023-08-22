
import Foundation

protocol DetailedCollectionPresenterProtocol {
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
    func didTapOnLink(url: URL?)
    func didTapCartButton(id: String)
    func didTapLikeButton(id: String)
    func didChooseNft(with id: String)
}
