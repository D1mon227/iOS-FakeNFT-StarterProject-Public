import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/profile/1")
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
