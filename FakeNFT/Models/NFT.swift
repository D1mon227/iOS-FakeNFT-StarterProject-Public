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

	var formattedPrice: String {
		return String(format: "%.2f ETH", price ?? 0.0).replacingOccurrences(of: ".", with: ",")
	}
}

struct Like: Encodable {
	var likes: [String]?
}
