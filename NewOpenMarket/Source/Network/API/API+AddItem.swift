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
            
            // FIXME: 이미지를 '압축' 하고 편집해서 POST 하는 과정에서 뭔가 왜곡이 일어나는 것 같음. 고화질 이미지의 경우, 아주 일부분만 편집돼 업로드되는 현상을 발견함!
            // 사이즈가 굉장히 큰 이미지는 720px 정방형으로 잘리면서, 썸네일에 올라가는 반면, 원래 사이즈가 그대로 보존되면서 url 에 올라가는 현상도 관찰함
            // 모바일에서 하니까, 정방형 사진이라도 우측으로 90도 돌아가는 이슈도 해결해야 함
            
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
            self.imagesAsData = images.compactMap { $0.jpegData(compressionQuality: .zero) }
        }
    }
}
