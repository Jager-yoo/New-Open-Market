//
//  Item.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import Foundation

struct Item: Decodable, Identifiable {
    
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let description: String? // 상품 상세에만 있는 요소는 옵셔널 처리
    let images: [ImageForResponse]?
    let vendor: Vendor?
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        
        case vendorID = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case vendor = "vendors"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case id, name, thumbnail, currency, price, stock, description, images
    }
}
