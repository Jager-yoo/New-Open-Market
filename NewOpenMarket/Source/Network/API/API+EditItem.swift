//
//  API+EditItem.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/26.
//

import Foundation

extension API {
    
    struct EditItem: APIRequest {
        
        var httpMethod: HTTPMethod = .patch
        var path: String {
            return "/api/products/\(itemID)"
        }
        var query: [String: Int] = [:]
        var body: Data? {
            guard let encodedItem = try? jsonManager.encode(from: item) else {
                return nil
            }
            
            return encodedItem
        }
        var headers: [String: String] {
            [
                "identifier": identifier,
                "Content-Type": "application/json"
            ]
        }
        var responseType = Item.self
        
        private let itemID: Int
        private let item: ItemForRequest
        
        init(itemID: Int, name: String, descriptions: String, currency: Currency, price: String, discount: String, stock: String) {
            self.itemID = itemID
            self.item = ItemForRequest(name: name, descriptions: descriptions, currency: currency, price: price, discount: discount, stock: stock)
        }
    }
}
