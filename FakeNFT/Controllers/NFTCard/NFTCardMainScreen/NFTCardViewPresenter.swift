//import Foundation
//
//final class NFTCardViewPresenter: NFTCardViewPresenterProtocol {
//    weak var view: NFTCardViewControllerProtocol?
//    
//    var nftModel: NFT? {
//        didSet {
//            DispatchQueue.main.async {
//                self.view?.updateNFTDetails(nftModel: self.nftModel)
//            }
//        }
//    }
//    
//    var isLiked: Bool? {
//        didSet {
//            guard let isLiked = self.isLiked else { return }
//            view?.updateLikeButton(isLiked: isLiked)
//        }
//    }
//}
