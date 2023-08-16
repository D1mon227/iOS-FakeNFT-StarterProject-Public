import Foundation

struct NFTsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.nft)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
