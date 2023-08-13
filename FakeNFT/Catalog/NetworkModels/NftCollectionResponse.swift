struct NftCollectionResponse: Codable {
    let id: String
    let name: String
    let nfts: [String]
    let cover: String
    let description: String
    let author: String
}
