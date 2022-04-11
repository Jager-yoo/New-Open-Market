//
//  ItemsListView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemsListView: View {
    
    @StateObject private var viewModel = ItemsListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($viewModel.items) { item in
                    NavigationLink {
                        ItemDetailView(item: item.wrappedValue)
                    } label: {
                        ItemsListRowView(item: item.wrappedValue)
                            .task {
                                // 무한 스크롤 로직
                                await viewModel.runInfiniteScroll(via: item.id)
                            }
                    }
                }
            }
            .padding()
        }
        .task {
            await viewModel.fetchFirstItemsPage()
        }
    }
}

private extension ItemsListView {
    
    final class ItemsListViewModel: ObservableObject {
        
        @Published var currentPage: Int = 1
        @Published var hasNextPage: Bool = false
        @Published var items: [Item] = []
        
        private static let paginationBuffer: Int = 3
        
        func runInfiniteScroll(via itemID: Int) async {
            if hasNextPage, itemID == items[items.count - Self.paginationBuffer].id {
                await fetchItems(page: currentPage + 1)
            }
        }
        
        func fetchItems(page: Int) async {
            do {
                let itemsPage = try await API.FetchItemsPage(pageNo: page, itemsPerPage: 20).asyncExecute()
                DispatchQueue.main.async { [weak self] in
                    self?.currentPage = itemsPage.pageNo
                    self?.hasNextPage = itemsPage.hasNext
                    self?.items.append(contentsOf: itemsPage.items)
                }
                print("💚 \(itemsPage.pageNo)번째 페이지 append 완료!")
            } catch {
                // Alert 띄우기
                print("⚠️ ItemsPage 통신 중 에러 발생! -> \(error.localizedDescription)")
                return
            }
        }
        
        func fetchFirstItemsPage() async {
            if items.isEmpty {
                await fetchItems(page: 1)
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
