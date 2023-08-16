import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.BaseURL.baseURL + "profile/1")
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
