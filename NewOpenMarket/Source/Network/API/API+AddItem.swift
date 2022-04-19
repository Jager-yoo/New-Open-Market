//
//  API+AddItem.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/07.
//

import UIKit

extension API {
    
    struct AddItem: APIRequest {
        
        var httpMethod: HTTPMethod = .post
        var path: String = "/api/products"
        var query: [String: Int] = [:]
        var body: Data? {
            guard let encodedItem = try? jsonManager.encode(from: item) else {
                return nil
            }
            
            var bodyTest = Data()
            
            bodyTest.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
            bodyTest.append("Content-Disposition: form-data; name=\"params\"\(lineBreak)".data(using: .utf8)!)
            bodyTest.append("Content-Type: application/json\(lineBreak)".data(using: .utf8)!)
            bodyTest.append(lineBreak.data(using: .utf8)!)
            bodyTest.append(encodedItem)
            bodyTest.append("\(lineBreak)\(lineBreak)".data(using: .utf8)!)
            
            images.forEach { imageData in
                bodyTest.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
                bodyTest.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(UUID().uuidString).jpeg\"\(lineBreak)".data(using: .utf8)!)
                bodyTest.append("Content-Type: image/jpeg\(lineBreak)".data(using: .utf8)!)
                bodyTest.append(lineBreak.data(using: .utf8)!)
                bodyTest.append(imageData)
                bodyTest.append("\(lineBreak)\(lineBreak)".data(using: .utf8)!)
            }
            
            bodyTest.append("--\(boundary)--".data(using: .utf8)!)
            
            return bodyTest
        }
        var headers: [String: String] {
            [
                "identifier": identifier,
                "Content-Type": "multipart/form-data; boundary=\(boundary)"
            ]
        }
        var responseType = Item.self
        
        private let item: ItemForRequest
        private let images: [Data]
        
        init(images: [UIImage], name: String, descriptions: String, currency: Currency, price: String, discount: String, stock: String) {
            self.item = ItemForRequest(name: name, descriptions: descriptions, currency: currency, price: price, discount: discount, stock: stock)
            self.images = images.compactMap { $0.jpegData(compressionQuality: .zero) }
        }
    }
}
