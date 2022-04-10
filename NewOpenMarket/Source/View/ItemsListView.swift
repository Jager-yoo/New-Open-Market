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
    
    private static let paginationBuffer: Int = 3
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($items) { item in
                    NavigationLink {
                        ItemDetailView(item: item)
                    } label: {
                        ItemsListRowView(item: item)
                            .task {
                                // 무한 스크롤 로직
                                if hasNextPage, item.id == items[items.count - Self.paginationBuffer].id {
                                    await fetchItems(page: currentPage + 1)
                                }
                            }
                    }

                }
            }
            .padding()
        }
        .task {
            if items.isEmpty {
                await fetchItems(page: 1) // 최초 다운로드
            }
        }
    }
    
    private func fetchItems(page: Int) async {
        // [weak self] 신경쓰기! -> 근데 여긴 class 타입의 뷰컨이 아니고 구조체라서 상관 없나? 🤔
        do {
            let itemsPage = try await API.FetchItemsPage(pageNo: page, itemsPerPage: 20).asyncExecute()
            currentPage = itemsPage.pageNo
            hasNextPage = itemsPage.hasNext
            items.append(contentsOf: itemsPage.items)
            print("💚 \(itemsPage.pageNo)번째 페이지 append 완료!")
        } catch {
            // Alert 띄우기
            print("⚠️ ItemsPage 통신 중 에러 발생! -> \(error.localizedDescription)")
            return
        }
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
