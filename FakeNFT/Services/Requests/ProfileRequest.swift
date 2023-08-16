import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.profile)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
