import UIKit

struct CatalogTableViewCellViewModel {
    let imageStringUrls: [String]
    let nftName: String
    let nftCount: String
    
//    init(nftCodable: NftCodable) {
//        imageStringUrls = []
//        nftName = nftCodable.name
//        nftCount = nftCodable.count
//    }
}

final class CatalogTableViewCell: UITableViewCell {
    
    
    func configure(with viewModel: CatalogTableViewCellViewModel) {

    }
}

