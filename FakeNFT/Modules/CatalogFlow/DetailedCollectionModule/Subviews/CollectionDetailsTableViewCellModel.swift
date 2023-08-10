
import Foundation

protocol DetailedCollectionTableViewCellProtocol {}

struct CollectionDetailsTableViewCellModel: DetailedCollectionTableViewCellProtocol {
    let collectionId: String
    let website: URL?
    let authorName: String
    let collectionName: String
    let collectionDescription: String
    
    init(collectionId: String,
         user: ProfileModel,
         collectionDescription: String,
         collectionName: String
    ) {
        self.collectionId = collectionId
        self.website = user.website
        self.authorName = user.name
        self.collectionDescription = collectionDescription
        self.collectionName = collectionName
    }
}

