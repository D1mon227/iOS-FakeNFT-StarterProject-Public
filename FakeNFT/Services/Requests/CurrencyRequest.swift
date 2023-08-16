import Foundation

struct CurrencyRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.BaseURL.baseURL + "currencies")
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
