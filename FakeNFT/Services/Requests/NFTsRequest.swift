import Foundation

struct NFTsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.BaseURL.baseURL + "nft")
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
