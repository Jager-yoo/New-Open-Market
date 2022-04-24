//
//  Double+stringFormat.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/25.
//

import Foundation

extension Double {
    
    private static let numberFormatter = NumberFormatter()
    
    var asMoney: String {
        Self.numberFormatter.numberStyle = .decimal
        let result = Self.numberFormatter.string(for: self) ?? self.description
        return result
    }
    
    var asString: String {
        return Int(self).description
    }
}
