import Foundation

struct NFT: Decodable {
    var createdAt: String?
    var name: String?
    var images: [URL]?
    var rating: Int?
    var description: String?
    var price: Double?
    var author: String?
    var id: String?
}

struct Like: Encodable {
    var likes: [String]?
}
