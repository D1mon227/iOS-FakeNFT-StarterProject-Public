import Foundation

struct NFT: Decodable {
	let createdAt: String?
    let name: String?
    let images: [URL]?
    let rating: Int?
    let description: String?
    let price: Double?
    let author: String?
    let id: String?
}
