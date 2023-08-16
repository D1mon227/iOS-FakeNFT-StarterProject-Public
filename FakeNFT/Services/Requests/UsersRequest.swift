import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.users)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
