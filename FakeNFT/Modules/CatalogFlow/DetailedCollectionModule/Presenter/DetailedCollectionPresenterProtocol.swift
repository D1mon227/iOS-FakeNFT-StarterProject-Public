
import Foundation

protocol DetailedCollectionPresenterProtocol {
    func viewDidLoad()
    func didTapOnLink(url: URL?)
    func didTapCartButton(id: String)
    func didTapLikeButton(id: String)
}
