//
//  Vendor.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import Foundation

struct Vendor: Decodable {
    
    let name: String
    let id: Int
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case name, id
    }
}
