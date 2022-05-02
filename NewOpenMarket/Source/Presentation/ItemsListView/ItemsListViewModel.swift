//
//  ItemsListViewModel.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/05/02.
//

import Foundation

final class ItemsListViewModel: ObservableObject {
    
    @Published var currentPage: Int = 1
    @Published var hasNextPage: Bool = false
    @Published var items: [Item] = []
    @Published var delayingRefresh: Bool = false
    @Published var goingDetail: Bool = false
    @Published var fetchedItemDetail: Item?
    @Published var isAddingItem: Bool = false
    @Published var shouldRefreshList: Bool = false
    
    let paginationBuffer: Int = 3
    let refreshDelaySecond: Double = 1.5
    
    func fetchItems(page: Int) async {
        do {
            let itemsPage = try await API.FetchItemsPage(pageNo: page, itemsPerPage: 20).asyncExecute()
            DispatchQueue.main.async {
                self.currentPage = itemsPage.pageNo
                self.hasNextPage = itemsPage.hasNext
                self.items.append(contentsOf: itemsPage.items)
            }
            print("📃 \(itemsPage.pageNo)번째 페이지 append 완료!")
        } catch {
            print("⚠️ ItemsPage 통신 중 에러 발생! -> \(error)")
            return
        }
    }
    
    func fetchDetail(itemID: Int) async {
        do {
            print("📟 fetchDetail -> id : \(itemID) 다운로드!")
            HapticManager.shared.selection()
            let fetchedItemDetail = try await API.FetchItemDetail(itemID: itemID).asyncExecute()
            DispatchQueue.main.async {
                self.fetchedItemDetail = fetchedItemDetail
                self.goingDetail = true
            }
        } catch {
            print("⚠️ ItemDetail 통신 중 에러 발생! -> \(error)")
            return
        }
    }
    
    func fetchFirstItemsPage() async {
        if items.isEmpty {
            await fetchItems(page: 1)
        }
    }
    
    func runInfiniteScroll(via itemID: Int) async {
        if hasNextPage, itemID == items[items.count - paginationBuffer].id {
            await fetchItems(page: currentPage + 1)
        }
    }
    
    func refreshItemsList() async {
        print("♻️ 리프레시 작동!")
        HapticManager.shared.selection()
        resetItemsList()
        delayingRefresh = true
        await fetchFirstItemsPage()
        DispatchQueue.main.asyncAfter(deadline: .now() + refreshDelaySecond) {
            self.delayingRefresh = false
        }
    }
    
    func conditionalRefreshItemsList() async {
        if shouldRefreshList {
            await refreshItemsList()
            DispatchQueue.main.async {
                self.shouldRefreshList = false
            }
        }
    }
    
    func showItemFormView() {
        isAddingItem = true
        HapticManager.shared.selection()
    }
    
    private func resetItemsList() {
        items.removeAll()
        currentPage = 1
        hasNextPage = false
    }
}
