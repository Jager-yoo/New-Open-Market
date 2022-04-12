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
    @State private var listMode: Bool = true
    @State private var delayingRefresh: Bool = false
    @State private var goingDetail: Bool = false
    @State private var preparedItemDetail: Item?
    
    private static let paginationBuffer: Int = 3
    private static let refreshDelaySecond: Double = 1.5
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($items) { item in
                    ItemsListRowUI(item: item.wrappedValue)
                        .task {
                            // 무한 스크롤 로직
                            await runInfiniteScroll(via: item.id)
                        }
                        .onTapGesture {
                            print("✋🏻 탭!!!!")
                            Task {
                                await fetchDetail(itemID: item.id)
                            }
                        }
                }
            }
            .padding()
            
            // ForEach 또는 LazyVStack 내부에 있게 되면, ListRow 하나가 화면에 그려질 때마다, 계속해서 인스턴스가 불필요하게 생성됨
            // 따라서, 같은 ScrollView 내부로 분리만 해두면, 스크롤 뷰가 늘어날 때(페이지네이션)랑, 사용자에 의해 눌릴 때만 인스턴스가 생성됨
            NavigationLink("", isActive: $goingDetail) {
                if let preparedItemDetail = preparedItemDetail {
                    ItemDetailView(itemDetail: preparedItemDetail)
                } else {
                    NetworkDisabledUI()
                }
            }
        }
        .task {
            await fetchFirstItemsPage()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("", selection: $listMode) {
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
                        await refreshItemsList()
                        // FIXME: 어떻게 하면 스크롤 관성을 멈출 수 있을까?
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(delayingRefresh)
            }
        }
    }
    
    private func fetchItems(page: Int) async {
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
    
    private func fetchDetail(itemID: Int) async {
        do {
            print("📟 fetchDetail -> id : \(itemID) 다운로드!")
            preparedItemDetail = try await API.FetchItemDetail(itemID: itemID).asyncExecute()
            goingDetail = true
        } catch {
            // Alert 띄우기
            print("⚠️ ItemDetail 통신 중 에러 발생! -> \(error.localizedDescription)")
            return
        }
    }
    
    private func fetchFirstItemsPage() async {
        if items.isEmpty {
            await fetchItems(page: 1)
        }
    }
    
    private func runInfiniteScroll(via itemID: Int) async {
        if hasNextPage, itemID == items[items.count - Self.paginationBuffer].id {
            await fetchItems(page: currentPage + 1)
        }
    }
    
    private func refreshItemsList() async {
        resetItemsList()
        delayingRefresh = true
        await fetchFirstItemsPage()
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.refreshDelaySecond) {
            self.delayingRefresh = false
        }
    }
    
    private func resetItemsList() {
        items.removeAll()
        currentPage = 1
        hasNextPage = false
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
