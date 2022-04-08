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
                        .font(.headline)
                    Spacer()
                    if item.stock == 0 {
                        Text("품절")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    } else {
                        Text("잔여수량 : \(item.stock)")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                
                HStack {
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
