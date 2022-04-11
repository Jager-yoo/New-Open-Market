//
//  ItemDetailView+Model.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemDetailView: View {
    
    @StateObject private var viewModel: ItemDetailViewModel
    
    init(item: Item) {
        _viewModel = StateObject(wrappedValue: ItemDetailViewModel(item: item))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                AsyncImage(url: viewModel.thumbnailURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                Text(viewModel.imagesCount)
                    .foregroundColor(.teal)
                Text(viewModel.itemID)
                    .foregroundColor(.secondary)
                ItemStockUI(itemStock: viewModel.item.stock)
                ItemPriceUI(item: viewModel.item)
                Text(viewModel.uploaderName)
                Text(viewModel.uploadDate)
                Divider()
                Text(viewModel.itemDescription)
                Spacer()
            }
        }
        .font(.title2)
        .navigationTitle("\(viewModel.item.name)")
        .toolbar {
            Button {
                print("수정/삭제 버튼 눌림!")
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
        .task {
            await viewModel.fetchItemDetail()
            print("💛 ItemDetailView appears task 작동!")
        }
    }
}

private extension ItemDetailView {
    
    final class ItemDetailViewModel: ObservableObject {
        
        @Published var itemDetail: Item? = nil
        let item: Item
        
        private static let placeholderText = "로딩 중"
        private static let placeholderURL = URL(string: "https://blog.yagom.net/wp-content/uploads/2020/02/yagom_icon.png")!
        
        init(item: Item) {
            self.item = item
        }
        
        var thumbnailURL: URL {
            return itemDetail?.thumbnail ?? Self.placeholderURL
        }
        
        var imagesCount: String {
            return "1 / \(itemDetail?.imagesCount ?? Self.placeholderText)"
        }
        
        var itemID: String {
            return "(상품 번호 : \(item.id.description))"
        }
        
        var uploaderName: String {
            return "게시자 : \(itemDetail?.vendor?.name ?? Self.placeholderText)"
        }
        
        var uploadDate: String {
            return "업로드 날짜 : \(item.createdAt.formatted())"
        }
        
        var itemDescription: String {
            return "\(itemDetail?.description ?? Self.placeholderText)"
        }
        
        func fetchItemDetail() async {
            do {
                let itemDetail = try await API.FetchItemDetail(itemID: item.id).asyncExecute()
                DispatchQueue.main.async { [weak self] in
                    self?.itemDetail = itemDetail
                }
            } catch {
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
