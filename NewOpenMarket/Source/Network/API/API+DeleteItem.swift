//
//  API+DeleteItem.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/24.
//

import Foundation

extension API {
    
    struct DeleteItem: APIRequest {
        
        var httpMethod: HTTPMethod = .delete
        var path: String {
            return "/api/products/\(itemID)/\(itemSecret)"
        }
        var query: [String: Int] = [:]
        var body: Data?
        var headers: [String: String] {
            [
                "identifier": identifier,
                "Content-Type": "application/json"
            ]
        }
        var responseType = Item.self
        
        private let itemID: Int
        private let itemSecret: String
        
        init(itemID: Int, itemSecret: String) {
            self.itemID = itemID
            self.itemSecret = itemSecret
        }
    }
}
