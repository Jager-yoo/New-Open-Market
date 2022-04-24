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
    let currency: Currency
    let price: Double
    let discount: Double // 디폴트 0
    let stock: Int // 디폴트 0
    let thumbnailID: URL? = nil // 상품 수정할 때만 필요한 프로퍼티
    let secret: String = "#YAkY88u7cpy2K@9" // '4기 예거' vender secret
    
    init(name: String, descriptions: String, currency: Currency, price: String, discount: String, stock: String) {
        self.name = name
        self.descriptions = descriptions
        self.currency = currency
        self.price = Double(price) ?? 0
        self.discount = Double(discount) ?? 0
        self.stock = Int(stock) ?? 0
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case discount = "discounted_price"
        case thumbnailID = "thumbnail_id"
        case name, descriptions, currency, price, stock, secret
    }
}
