import Foundation

struct Profile: Decodable {
    var name: String
    var avatar: URL
    var description: String
    var website: String
    var nfts: [String]
    var likes: [String]
}

struct NewProfile: Encodable {
    var name: String?
    var description: String?
    var website: String?
}
