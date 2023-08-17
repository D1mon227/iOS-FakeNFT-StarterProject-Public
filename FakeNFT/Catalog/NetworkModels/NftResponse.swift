struct NftResponse: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    
    var formattedPrice: String {
        return String(format: "%.2f ETH", price).replacingOccurrences(of: ".", with: ",")
    }
}

