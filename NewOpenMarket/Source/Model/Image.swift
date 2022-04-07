//
//  Image.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import Foundation

struct Image: Decodable { // SwiftUI 에서의 Image 구조체와 충돌 가능성 있음
    
    let id: Int
    let url: String
    let thumbnailURL: String
    let succeed: Bool
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
        case id, url, succeed
    }
}
