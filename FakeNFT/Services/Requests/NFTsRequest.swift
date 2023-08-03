import Foundation

struct NFTsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/nft")
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
