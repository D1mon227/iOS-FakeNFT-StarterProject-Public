import Foundation

protocol NFTCardCollectionViewCellDelegate: AnyObject {
    func didTapLike(_ cell: NFTCardCollectionViewCell)
    func didTapCart(_ cell: NFTCardCollectionViewCell)
}
