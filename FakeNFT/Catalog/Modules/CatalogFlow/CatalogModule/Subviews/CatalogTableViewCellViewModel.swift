import UIKit

struct CatalogTableViewCellViewModel {
    let id: String
    let imageStringUrl: URL?
    let nftCount: Int
    let nftName: String
    var imageData: Data?
    
    var nftTitle: String {
        nftName + " (\(nftCount))"
    }
    
    init(nftResponse: NFTCollection) {
        self.id = nftResponse.id ?? ""
        self.imageStringUrl = nftResponse.cover?.makeUrl()
        self.nftName = nftResponse.name ?? ""
        self.nftCount = nftResponse.nfts?.count ?? 0
    }
}
