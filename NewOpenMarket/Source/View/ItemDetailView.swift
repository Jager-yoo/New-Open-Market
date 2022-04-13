//
//  ItemDetailView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemDetailView: View {
    
    let itemDetail: Item
    
    private static let placeholderText = "로딩 실패"
    
    var body: some View {
        ScrollView {
            TabView {
                // FIXME: force unwrapping
                ForEach(itemDetail.images!) { image in
                    AsyncImage(url: image.url) { eachImage in
                        eachImage.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .border(.red, width: 3)
                }
            }
            .scaledToFit()
            .border(.blue, width: 3)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack(alignment: .leading, spacing: 10) {
                Text("1 / \(itemDetail.imagesCount)")
                    .foregroundColor(.teal)
                Text("(상품 번호 : \(itemDetail.id.description))")
                    .foregroundColor(.secondary)
                ItemStockUI(itemStock: itemDetail.stock)
                ItemPriceUI(item: itemDetail)
                Text("게시자 : \(itemDetail.vendor?.name ?? Self.placeholderText)")
                Text("업로드 날짜 : \(itemDetail.createdAt.formatted())")
                Divider()
                Text(itemDetail.description ?? Self.placeholderText)
            }
        }
        .font(.title2)
        .navigationTitle("\(itemDetail.name)")
        .toolbar {
            Button {
                print("수정/삭제 버튼 눌림!")
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
    }
}
