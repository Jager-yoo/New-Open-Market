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
    
    private static let placeholderText = "로딩 중"
    private static let placeholderURL = URL(string: "")
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                AsyncImage(url: itemDetail?.thumbnail ?? Self.placeholderURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                Text("1 / \(itemDetail?.imagesCount ?? Self.placeholderText)")
                    .foregroundColor(.teal)
                Text("(상품 번호 : \(item.id.description))")
                    .foregroundColor(.secondary)
                ItemStockUI(itemStock: item.stock)
                ItemPriceUI(item: item)
                Text("게시자 : \(itemDetail?.vendor?.name ?? Self.placeholderText)")
                Text("업로드 날짜 : \(item.createdAt.formatted())")
                Divider()
                Text("\(itemDetail?.description ?? Self.placeholderText)")
                Spacer()
            }
        }
        .font(.title2)
        .navigationTitle("\(item.name)")
        .toolbar {
            Button {
                print("수정/삭제 버튼 눌림!")
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
        .task {
            await fetchItemDetail(itemID: item.id)
            print("💛 ItemDetailView appears task 작동!")
        }
    }
    
    private func fetchItemDetail(itemID: Int) async {
        do {
            let itemDetail = try await API.FetchItemDetail(itemID: itemID).asyncExecute()
            self.itemDetail = itemDetail
        } catch {
            // Alert 띄우기
            print("⚠️ ItemDetail 통신 중 에러 발생! -> \(error.localizedDescription)")
            return
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
