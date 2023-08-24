import Foundation

//MARK: Profile
struct ProfileGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.profile)
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

struct ProfilePutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.profile)
    }
    var httpMethod: HttpMethod { .put }
    let dto: Encodable?
}

//MARK: NFTs
struct NFTsGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.nft)
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

struct NFTsGetRequestByID: NetworkRequest {
    let nftId: String
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.nft + "/\(nftId)")
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

//MARK: Users
struct UsersGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.users)
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

//MARK: Currency
struct CurrencyGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.currencies)
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

//MARK: NFTCollections
struct NFTCollectionGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.nftCollection)
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

//MARK: Cart
struct CartGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.orders)
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

struct CartPutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.orders)
    }
    var httpMethod: HttpMethod { .put }
    var dto: Encodable?
}

//MARK: Payment
//struct CartPutRequest: NetworkRequest {
//    var endpoint: URL? {
//        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.orders)
//    }
//    var httpMethod: HttpMethod { .put }
//    var dto: Encodable?
//}
