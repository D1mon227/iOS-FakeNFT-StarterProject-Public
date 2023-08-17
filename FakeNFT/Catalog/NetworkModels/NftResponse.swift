struct NftResponse: Codable {
    let id: String
    let description: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let author: String
    let createdAt: String
    
    var formattedPrice: String {
        return String(format: "%.2f", price).replacingOccurrences(of: ".", with: ",")
    }
}

