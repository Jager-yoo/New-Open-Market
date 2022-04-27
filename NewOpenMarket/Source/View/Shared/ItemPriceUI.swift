//
//  ItemPriceUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/09.
//

import SwiftUI

struct ItemPriceUI: View {
    
    let item: Item
    
    var body: some View {
        Group {
            if isFree {
                Text("나눔 🧡")
            } else if isDiscounted {
                Text("\(item.formattedPrice)")
                    .foregroundColor(.red)
                    .strikethrough()
                Text("\(item.formattedBargainPrice)")
            } else {
                Text("\(item.formattedPrice)") // 정상 가격
            }
        }
        .foregroundColor(.secondary)
    }
    
    private var isDiscounted: Bool {
        item.discountedPrice > 0
    }
    
    private var isFree: Bool {
        item.price.isZero || item.bargainPrice.isZero
    }
}
