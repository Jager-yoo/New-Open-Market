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
            
            var body = Data()
            
            body.append("--\(boundary)" + lineBreak)
            body.append("Content-Disposition: form-data; name=\"params\"" + lineBreak)
            body.append("Content-Type: application/json" + lineBreak + lineBreak) // 여기 반드시 lineBreak 2개 필요!
            body.append(encodedItem)
            body.append(lineBreak)
            
            imagesAsData.forEach { imageData in
                body.append("--\(boundary)" + lineBreak)
                body.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(UUID().uuidString).jpeg\"" + lineBreak)
                body.append("Content-Type: image/jpeg" + lineBreak + lineBreak) // 여기 반드시 lineBreak 2개 필요!
                body.append(imageData)
                body.append(lineBreak)
            }
            
            body.append("--\(boundary)--")
            
            return body
        }
        var headers: [String: String] {
            [
                "identifier": identifier,
                "Content-Type": "multipart/form-data; boundary=\(boundary)"
            ]
        }
        var responseType = Item.self
        
        private let item: ItemForRequest
        private let imagesAsData: [Data]
        
        init(images: [UIImage], name: String, descriptions: String, currency: Currency, price: String, discount: String, stock: String) {
            self.item = ItemForRequest(name: name, descriptions: descriptions, currency: currency, price: price, discount: discount, stock: stock)
            let croppedImages: [CGImage] = images.compactMap {
                $0.cropAsSquare()
            }
            self.imagesAsData = croppedImages.compactMap {
                return UIImage(cgImage: $0).jpegData(compressionQuality: .zero)
            }
        }
    }
}
