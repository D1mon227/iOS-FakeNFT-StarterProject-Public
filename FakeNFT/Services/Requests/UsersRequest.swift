import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://64c5171bc853c26efada7b56.mockapi.io/api/v1/users")
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
