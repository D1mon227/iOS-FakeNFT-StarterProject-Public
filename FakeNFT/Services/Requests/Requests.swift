import Foundation

//MARK: Profile
struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.profile)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}

//MARK: NFTs
struct NFTsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.nft)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}

struct NFTsRequestByID: NetworkRequest {
    let nftId: String
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.nft + "/\(nftId)")
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}

//MARK: Users
struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.users)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}

//MARK: Currency
struct CurrencyRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.currencies)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}

//MARK: NFTCollections
struct NFTCollectionRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.nftCollection)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}

//MARK: Cart
struct CartRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: Resourses.Network.baseURL + Resourses.Network.Paths.orders)
    }
    let httpMethod: HttpMethod
    let dto: Encodable?
}
