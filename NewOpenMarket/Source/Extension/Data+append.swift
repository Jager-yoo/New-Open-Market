//
//  Data+append.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/21.
//

import Foundation

extension Data {
    
    /// string 타입을 data 로 변환하여 호출한 data 의 끝에 append 합니다.
    mutating func append(_ message: String) {
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        self.append(data)
    }
}
