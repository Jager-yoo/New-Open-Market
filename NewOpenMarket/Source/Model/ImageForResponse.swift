//
//  ImageForResponse.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import Foundation

struct ImageForResponse: Decodable, Identifiable {
    
    let id: Int
    let url: URL
    let thumbnailURL: URL
    let succeed: Bool
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
        case id, url, succeed
    }
}
