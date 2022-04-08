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
        List($items) { item in
            NavigationLink {
                ItemDetailView(item: item)
            } label: {
                ItemsListRowView(item: item)
            }
        }
        .listStyle(.plain)
        .onAppear {
            // FIXME: DetailView 들어갔다가 나오면 계속 호출되는 이슈 있음
            fetchItems(page: 1)
            print("💚 ItemsListView onAppear 발생!")
        }
    }
    
    private func fetchItems(page: Int) {
        // [weak self] 신경쓰기! -> 근데 여긴 class 타입의 뷰컨이 아니고 구조체라서 상관 없나? 🤔
        API.FetchItemsPage(pageNo: page, itemsPerPage: 20).execute { result in
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
