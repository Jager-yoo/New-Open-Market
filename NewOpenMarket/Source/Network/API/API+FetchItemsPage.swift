//
//  API+FetchItemsPage.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/07.
//

import Foundation

extension API {
    
    struct FetchItemsPage: APIRequest {
        
        var httpMethod: HTTPMethod = .get
        var path: String = "/api/products"
        var query: [String: Int] {
            [
                "pageNo": pageNo,
                "itemsPerPage": itemsPerPage
            ]
        }
        var body: Data? = nil
        var headers: [String: String] {
            return ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        }
        var responseType = ItemsPage.self
        
        private let pageNo: Int
        private let itemsPerPage: Int
        
        init(pageNo: Int, itemsPerPage: Int) {
            self.pageNo = pageNo
            self.itemsPerPage = itemsPerPage
        }
    }
}
