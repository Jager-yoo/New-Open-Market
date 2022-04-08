//
//  ItemForRequest.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/07.
//

import Foundation

struct ItemForRequest: Encodable {
    
    let name: String // 글자 count 3 ~ 100
    let descriptions: String // 글자 count 10 ~ 1,000
    let price: Double
    let currency: Currency
    let discountedPrice: Double // 디폴트 0
    let stock: Int // 디폴트 0
    let thumbnailID: URL? // 상품 수정할 때만 필요한 프로퍼티
    let secret: String
    
    private enum CodingKeys: String, CodingKey {
        
        case discountedPrice = "discounted_price"
        case thumbnailID = "thumbnail_id"
        case name, descriptions, price, currency, stock, secret
    }
}
