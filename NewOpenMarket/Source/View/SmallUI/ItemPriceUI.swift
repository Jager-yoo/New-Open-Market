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
        if item.discountedPrice == 0 {
            Text("\(item.formattedPrice)")
                .foregroundColor(.secondary)
        } else {
            Text("\(item.formattedPrice)")
                .foregroundColor(.red)
                .strikethrough()
            Text("\(item.formattedBargainPrice)")
                .foregroundColor(.secondary)
        }
    }
}
