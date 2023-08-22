import Foundation

final class CurrencyService {
    static let shared = CurrencyService()
    private let networkClient = DefaultNetworkClient()
    
    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        
        UIBlockingProgressHUD.show()
        let request = CurrencyRequest(httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: [Currency].self) { result in
            switch result {
            case .success(let currency):
                completion(.success(currency))
            case .failure(let error):
                completion(.failure(error))
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
