//
//  ItemsListView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemsListView: View {
    
    @State private var currentPage: Int = 1
    @State private var hasNextPage: Bool = false
    @State private var items: [Item] = []
    
    var body: some View {
        NavigationView {
            List(items) { item in
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
            .listStyle(.plain)
        }.onAppear {
            fetchItems(page: 1)
            print("💚 ItemsListView onAppear 발생!")
        }
    }
    
    private func fetchItems(page: Int) {
        // [weak self] 신경쓰기! -> 근데 여긴 class 타입의 뷰컨이 아니고 구조체라서 상관 없나? 🤔
        API.FetchItemsPage(pageNo: page, itemsPerPage: 10).execute { result in
            switch result {
            case .success(let itemsPage):
                currentPage = itemsPage.pageNo
                hasNextPage = itemsPage.hasNext
                items.append(contentsOf: itemsPage.items)
            case .failure(let error):
                // Alert 띄우기
                print("⚠️ ItemsPage 통신 중 에러 발생! -> \(error.localizedDescription)")
                return
            }
        }
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
