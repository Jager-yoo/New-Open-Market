//
//  API+FetchItemDetail.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import Foundation

extension API {
    
    struct FetchItemDetail: APIRequest {
        
        var httpMethod: HTTPMethod = .get
        var path: String {
            return "/api/products/\(itemID)"
        }
        var query: [String: Int] = [:]
        var body: Data? = nil
        var headers: [String: String] {
            ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        }
        var responseType = Item.self
        
        private let itemID: Int
        
        init(itemID: Int) {
            self.itemID = itemID
        }
    }
}
