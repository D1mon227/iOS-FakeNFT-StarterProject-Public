//
//  CartModel.swift
//  FakeNFT
//
//  Created by Денис on 04.08.2023.
//

import Foundation

protocol CartPresenterProtocol {
    typealias NFTCompletionHandler = (Result<Cart, Error>) -> Void
    typealias OrdersCompletionHandler = (Result<Order, Error>) -> Void
    
    func getNFTsFromAPI(nftID: String, completion: @escaping NFTCompletionHandler)
    func cartNFTs(completion: @escaping OrdersCompletionHandler)
    func changeCart(order: Order, completion: @escaping () -> Void)
}

final class CartPresenter: CartPresenterProtocol {
    
    private let cartService: CartServiceProtocol
    
    init(cartService: CartServiceProtocol = CartService()) {
        self.cartService = cartService
    }
    
    private let queue = DispatchQueue(label: "", qos: .background, attributes: .concurrent)
    
    func getNFTsFromAPI(nftID: String, completion: @escaping NFTCompletionHandler) {
        guard let url = URL(string: Resourses.Network.baseURL + "/api/v1/nft/" + nftID) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }
        
        queue.async {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let result = try decoder.decode(Cart.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                print("Error fetching cart data: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func cartNFTs(completion: @escaping OrdersCompletionHandler) {
        cartService.getOrder(id: "1") { result in
            switch result {
            case .success(let cartModelDecodable):
                let ordersStruct = Order(nfts: cartModelDecodable.nfts, id: "1")
                completion(.success(ordersStruct))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeCart(order: Order, completion: @escaping () -> Void) {
        let orderID = order.id
        
        let nftIDs = order.nfts
        
        let cartModel = CartModelDecodable(nfts: nftIDs, id: orderID)
        
        cartService.putOrder(cart: cartModel) { result in
            switch result {
            case .success:
                completion()
            case .failure(let error):
                print("Error updating cart data: \(error)")
            }
        }
    }
    
}
