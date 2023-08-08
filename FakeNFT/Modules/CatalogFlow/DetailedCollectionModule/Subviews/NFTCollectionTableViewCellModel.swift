
import Foundation

struct NFTCollectionTableViewCellModel {
    let id: String
    let website: URL?
    let name: String
    let nftsCollection: [String] = []
    let description: String = ""
    
    
    init(authorResponse: AuthorResponse) {
        self.id = authorResponse.id
        self.website = authorResponse.website.makeUrl()
        self.name = authorResponse.name
    }
}
