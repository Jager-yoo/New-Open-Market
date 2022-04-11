//
//  ItemsListView+Model.swift
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
                        ItemsListRowUI(item: item.wrappedValue)
                            .task {
                                // 무한 스크롤 로직
                                await viewModel.runInfiniteScroll(via: item.id)
                            }
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("", selection: $viewModel.listMode) {
                    Image(systemName: "rectangle.grid.1x2").tag(true)
                    Image(systemName: "rectangle.grid.2x2").tag(false)
                }
                .pickerStyle(.segmented)
                .frame(width: 180)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    Task {
                        print("♻️ 리프레시 작동!")
                        await viewModel.refreshItemsList()
                        // FIXME: 어떻게 하면 스크롤 관성을 멈출 수 있을까?
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.refreshDelay)
            }
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
        @Published var listMode: Bool = true
        @Published var refreshDelay: Bool = false
        
        private static let paginationBuffer: Int = 3
        private static let refreshDelaySecond: Double = 1.5
        
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
        
        func refreshItemsList() async {
            resetItemsList()
            refreshDelay = true
            await fetchFirstItemsPage()
            DispatchQueue.main.asyncAfter(deadline: .now() + Self.refreshDelaySecond) {
                self.refreshDelay = false
            }
        }
        
        private func resetItemsList() {
            items.removeAll()
            currentPage = 1
            hasNextPage = false
        }
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
