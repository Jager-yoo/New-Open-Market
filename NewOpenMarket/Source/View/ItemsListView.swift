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
    @State private var delayingRefresh: Bool = false
    @State private var goingDetail: Bool = false
    @State private var preparedItemDetail: Item?
    @State private var isAddingItem: Bool = false
    @State private var shouldRefreshList: Bool = false
    
    private static let paginationBuffer: Int = 3
    private static let refreshDelaySecond: Double = 1.5
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($items) { item in
                    Button {
                        Task {
                            await fetchDetail(itemID: item.id)
                            HapticManager.shared.selection()
                        }
                    } label: {
                        ItemsListRowUI(item: item.wrappedValue)
                            .task {
                                // 무한 스크롤 로직
                                await runInfiniteScroll(via: item.id)
                            }
                    }
                }
            }
            .padding()
        }
        .task {
            await fetchFirstItemsPage()
        }
        .background {
            // NavigationLink 의 Label 을 EmptyView() 로 두고, background 를 통해 View 뒤로 숨기는 방법
            // 인스턴스 생성을 최소화할 수 있지만, View 구조체 자체가 새롭게 갱신되는 경우에는 다시 생성된다. (toolbar 도 마찬가지)
            NavigationLink(isActive: $goingDetail) {
                if let preparedItemDetail = preparedItemDetail {
                    ItemDetailView(itemDetail: preparedItemDetail, isActive: $goingDetail, shouldRefreshList: $shouldRefreshList)
                        .onDisappear {
                            Task {
                                if shouldRefreshList {
                                    await refreshItemsList()
                                    shouldRefreshList = false
                                }
                            }
                        }
                } else {
                    ErrorView()
                }
            } label: {
                EmptyView()
            }
            .hidden() // NavigationLink 자체를 hidden 처리하면, [버튼 모양] 켰을 때 나타나는 작은 사각형이 사라짐!
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                isAddingItem = true
                HapticManager.shared.selection()
            } label: {
                addItemButton
            }
            .padding(25)
        }
        .fullScreenCover(isPresented: $isAddingItem, onDismiss: {
            Task {
                if shouldRefreshList {
                    await refreshItemsList()
                    shouldRefreshList = false
                }
            }
        }, content: {
            ItemFormView(isActive: $isAddingItem, shouldRefreshList: $shouldRefreshList)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    Task {
                        print("♻️ 리프레시 작동!")
                        await refreshItemsList()
                        HapticManager.shared.selection()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(delayingRefresh)
            }
        }
    }
    
    private var addItemButton: some View {
        Circle()
            .fill(AngularGradient(colors: [.orange, .yellow, .orange], center: .center))
            .frame(width: 70, height: 70)
            .shadow(radius: 3)
            .overlay {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(.white)
                    .padding(20)
            }
    }
    
    private func fetchItems(page: Int) async {
        do {
            let itemsPage = try await API.FetchItemsPage(pageNo: page, itemsPerPage: 20).asyncExecute()
            currentPage = itemsPage.pageNo
            hasNextPage = itemsPage.hasNext
            items.append(contentsOf: itemsPage.items)
            print("📃 \(itemsPage.pageNo)번째 페이지 append 완료!")
        } catch {
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
        Group {
            MainView()
                .previewDevice("iPhone 11")
            
            MainView()
                .previewDevice("iPhone SE (3rd generation)")
        }
    }
}
