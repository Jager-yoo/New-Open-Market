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
                AsyncImage(url: item.thumbnail) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: "eye.slash.fill") // 에러 발생 시 보여줄 이미지
                            .font(.title3)
                            .foregroundColor(.secondary)
                    } else {
                        ProgressView() // placeholder
                    }
                }
                .frame(width: 80, height: 80)
                .background(Color(uiColor: .secondarySystemBackground)) // 아주 연한 회색
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
