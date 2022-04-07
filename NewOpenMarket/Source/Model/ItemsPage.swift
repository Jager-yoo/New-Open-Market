//
//  ItemsPage.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import Foundation

struct ItemsPage: Decodable {
    
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int // 첫 번째 index
    let limit: Int // 마지막 index
    let items: [Item]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    private enum CodingKeys: String, CodingKey {
        
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case items = "pages"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
        case offset, limit
    }
}
