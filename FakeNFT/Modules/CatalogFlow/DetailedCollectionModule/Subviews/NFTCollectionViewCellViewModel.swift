import UIKit

struct NFTCollectionViewCellViewModel {
    let nftId: String
    let nftIcon: URL?
    let nftStarsCount: Int
    let nftName: String
    let nftPrice: String
    let isFavorite: Bool
    let isCartAdded: Bool
    
    init(nftResponse: NftResponse) {
        self.nftId = nftResponse.id
        self.nftIcon = nftResponse.images.first?.makeUrl()
        self.nftStarsCount = nftResponse.rating
        self.nftName = nftResponse.name
        self.isFavorite = false
        self.isCartAdded = false
        self.nftPrice = String(nftResponse.price)
    }
    
    init(nftId: String,
         nftIcon: URL?,
         nftStarsCount: Int,
         nftName: String,
         nftPrice: String,
         isFavorite: Bool,
         isCartAdded: Bool) {
        self.nftId = nftId
        self.nftIcon = nftIcon
        self.nftStarsCount = nftStarsCount
        self.nftName = nftName
        self.isFavorite = isFavorite
        self.isCartAdded = isCartAdded
        self.nftPrice = nftPrice
    }
    
    func makeNewModel(isFavorite: Bool) -> NFTCollectionViewCellViewModel {
        return NFTCollectionViewCellViewModel(nftId: self.nftId,
                                              nftIcon: self.nftIcon,
                                              nftStarsCount: self.nftStarsCount,
                                              nftName: self.nftName,
                                              nftPrice: self.nftPrice,
                                              isFavorite: isFavorite,
                                              isCartAdded: isCartAdded)
    }
    
    func makeNewModel(isCartAdded: Bool) -> NFTCollectionViewCellViewModel {
        return NFTCollectionViewCellViewModel(nftId: self.nftId,
                                              nftIcon: self.nftIcon,
                                              nftStarsCount: self.nftStarsCount,
                                              nftName: self.nftName,
                                              nftPrice: self.nftPrice,
                                              isFavorite: self.isFavorite,
                                              isCartAdded: isCartAdded)
    }
}
