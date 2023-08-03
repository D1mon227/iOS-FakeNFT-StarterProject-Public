import Foundation

struct Profile: Decodable {
    var name: String
    var avatar: URL
    var description: String
    var website: URL
    var nfts: [String]
    var likes: [String]
}
