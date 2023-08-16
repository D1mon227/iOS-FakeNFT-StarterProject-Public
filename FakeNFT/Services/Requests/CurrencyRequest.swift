import Foundation

struct CurrencyRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.currencies)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
