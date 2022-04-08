//
//  ItemsListRowView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemsListRowView: View {
    
    @Binding var item: Item
    
    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: item.thumbnail) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            
            VStack(spacing: 15) {
                HStack {
                    Text("\(item.name)")
                        .bold()
                    Spacer()
                    ItemStockComponent(itemStock: item.stock)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .font(.body)
                
                HStack {
                    ItemPriceComponent(item: item)
                    Spacer()
                }
                .font(.callout)
            }
        }
    }
}

struct ItemsListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
