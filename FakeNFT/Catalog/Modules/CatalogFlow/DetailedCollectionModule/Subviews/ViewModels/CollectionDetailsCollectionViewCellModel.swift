
import Foundation

protocol DetailedCollectionTableViewCellProtocol {}

struct CollectionDetailsCollectionViewCellModel: DetailedCollectionTableViewCellProtocol {
    let collectionId: String
    let website: String?
    let authorName: String
    let collectionName: String
    let collectionDescription: String
    let imageStringUrl: URL?
    
    init(collectionId: String,
         collectionDescription: String,
         collectionName: String,
         imageStringUrl: URL?,
         user: Profile
    ) {
        self.collectionId = collectionId
        self.website = user.website
        self.authorName = user.name ?? ""
        self.collectionDescription = collectionDescription
        self.collectionName = collectionName
        self.imageStringUrl = imageStringUrl
    }
}


