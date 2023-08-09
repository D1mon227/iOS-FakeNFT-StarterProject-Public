
import Foundation

protocol DetailedCollectionTableViewCellProtocol {}

struct NFTCollectionTableViewCellModel: DetailedCollectionTableViewCellProtocol {
    let collectionId: String
    let website: URL?
    let authorName: String
    let collectionName: String
    let collectionDescription: String
    
    init(collectionId: String,
         authorResponse: AuthorResponse,
         collectionDescription: String,
         collectionName: String
    ) {
        self.collectionId = collectionId
        self.website = authorResponse.website.makeUrl()
        self.authorName = authorResponse.name
        self.collectionDescription = collectionDescription
        self.collectionName = collectionName
    }
}
