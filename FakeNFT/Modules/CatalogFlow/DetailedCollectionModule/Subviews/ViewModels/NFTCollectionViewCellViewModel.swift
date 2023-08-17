import UIKit

struct NFTCollectionViewCellViewModel {
    let nftId: String
    let nftIcon: URL?
    let nftStarsCount: Int
    let nftName: String
    let nftPrice: String
    let favoriteButtonImageName: ImageModel?
    let cartButtonImageName: ImageModel?
    
    init(nftResponse: NftResponse) {
        self.nftId = nftResponse.id
        self.nftIcon = nftResponse.images.first?.makeUrl()
        self.nftStarsCount = nftResponse.rating
        self.nftName = nftResponse.name
        self.nftPrice = String(nftResponse.price)
        self.cartButtonImageName = nil
        self.favoriteButtonImageName = nil
    }
    
    init(nftId: String,
         nftIcon: URL?,
         nftStarsCount: Int,
         nftName: String,
         nftPrice: String,
         favoriteButtonImageName: ImageModel?,
         cartButtonImageName: ImageModel?) {
        self.nftId = nftId
        self.nftIcon = nftIcon
        self.nftStarsCount = nftStarsCount
        self.nftName = nftName
        self.favoriteButtonImageName = favoriteButtonImageName
        self.cartButtonImageName = cartButtonImageName
        self.nftPrice = nftPrice
    }
    
    func makeNewModel(favoriteButtonImageName: ImageModel) -> NFTCollectionViewCellViewModel {
        return NFTCollectionViewCellViewModel(nftId: self.nftId,
                                              nftIcon: self.nftIcon,
                                              nftStarsCount: self.nftStarsCount,
                                              nftName: self.nftName,
                                              nftPrice: self.nftPrice,
                                              favoriteButtonImageName: favoriteButtonImageName,
                                              cartButtonImageName: self.cartButtonImageName)
    }
    
    func makeNewModel(cartButtonImageName: ImageModel) -> NFTCollectionViewCellViewModel {
        return NFTCollectionViewCellViewModel(nftId: self.nftId,
                                              nftIcon: self.nftIcon,
                                              nftStarsCount: self.nftStarsCount,
                                              nftName: self.nftName,
                                              nftPrice: self.nftPrice,
                                              favoriteButtonImageName: self.favoriteButtonImageName,
                                              cartButtonImageName: cartButtonImageName)
    }
}
