//
//  ItemStockUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/09.
//

import SwiftUI

struct ItemStockUI: View {
    
    let itemStock: Int
    
    var body: some View {
        if itemStock == 0 {
            Text("품절")
                .bold()
                .foregroundColor(.yellow)
        } else {
            Text("잔여수량 : \(itemStock)")
                .foregroundColor(.secondary)
        }
    }
}
