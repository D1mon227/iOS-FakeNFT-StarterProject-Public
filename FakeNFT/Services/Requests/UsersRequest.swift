import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.BaseURL.baseURL + "users")
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
