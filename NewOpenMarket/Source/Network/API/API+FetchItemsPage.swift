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
                "page_no": pageNo,
                "items_per_page": itemsPerPage
            ]
        } // 쿼리 딕셔너리는 작성된 순서와 반대로 URL 뒤에 달라붙게 됨!
        var body: Data?
        var headers: [String: String] {
            ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
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
