//
//  API+FindItemSecret.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/21.
//

import Foundation

extension API {
    
    struct FindItemSecret: APIRequest {
        
        var httpMethod: HTTPMethod = .post
        var path: String {
            return "/api/products/\(itemID)/secret"
        }
        var query: [String: Int] = [:]
        var body: Data? {
            var body = Data()
            body.append("{\"secret\": \"\(vendorSecret)\"}")
            return body
        }
        var headers: [String: String] {
            [
                "identifier": identifier,
                "Content-Type": "application/json"
            ]
        }
        var responseType = Data.self
        
        private let itemID: Int
        
        init(itemID: Int) {
            self.itemID = itemID
        }
    }
}
