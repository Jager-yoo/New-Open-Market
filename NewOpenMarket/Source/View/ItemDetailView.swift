//
//  ItemDetailView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemDetailView: View {
    
    @Binding var item: Item
    @State private var itemDetail: Item? = nil
    private let placeholderText = "로딩 중"
    private let placeholderURL = URL(string: "")
    
    var body: some View {
        VStack(spacing: 10) {
            AsyncImage(url: itemDetail?.thumbnail ?? placeholderURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .scaledToFit()
            ItemStockComponent(itemStock: item.stock)
            ItemPriceComponent(item: item)
            Text("1 / \(itemDetail?.imagesCount ?? placeholderText)")
            Text("게시자 : \(itemDetail?.vendor?.name ?? placeholderText)")
            Text("업로드 날짜 : \(item.createdAt.formatted())")
            Text("내용 : \(itemDetail?.description ?? placeholderText)")
            Spacer()
        }
        .font(.title2)
        .navigationTitle("\(item.name)")
        .toolbar {
            Button {
                print("수정/삭제 버튼 눌림!")
            } label: {
                Image(systemName: "square.and.pencil")
                    .tint(Color.primary)
            }
        }
        .onAppear {
            fetchItemDetail(itemID: item.id)
            print("💛 ItemDetailView onAppear 발생!")
        }
    }
    
    private func fetchItemDetail(itemID: Int) {
        API.FetchItemDetail(itemID: itemID).execute { result in
            switch result {
            case .success(let itemDetail):
                self.itemDetail = itemDetail
            case .failure(let error):
                // Alert 띄우기
                print("⚠️ ItemDetail 통신 중 에러 발생! -> \(error.localizedDescription)")
                return
            }
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
