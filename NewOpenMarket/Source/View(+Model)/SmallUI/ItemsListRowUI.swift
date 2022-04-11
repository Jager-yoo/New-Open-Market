//
//  ItemsListRowUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemsListRowUI: View {
    
    let item: Item
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                AsyncImage(url: item.thumbnail) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                
                VStack(spacing: 15) {
                    HStack {
                        Text("\(item.name)")
                            .bold()
                        Spacer()
                        ItemStockUI(itemStock: item.stock)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        ItemPriceUI(item: item)
                        Spacer()
                    }
                    .font(.callout)
                }
            }
            Divider()
        }
    }
}
