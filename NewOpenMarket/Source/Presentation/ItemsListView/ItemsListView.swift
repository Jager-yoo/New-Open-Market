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
                    Button {
                        Task {
                            await viewModel.fetchDetail(itemID: item.id)
                        }
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
        .task {
            await viewModel.fetchFirstItemsPage()
        }
        .background {
            // NavigationLink 의 Label 을 EmptyView() 로 두고, background 를 통해 View 뒤로 숨기는 방법
            // 인스턴스 생성을 최소화할 수 있지만, View 구조체 자체가 새롭게 갱신되는 경우에는 다시 생성된다. (toolbar 도 마찬가지)
            NavigationLink(isActive: $viewModel.goingDetail) {
                if let fetchedItemDetail = viewModel.fetchedItemDetail {
                    ItemDetailView(itemDetail: fetchedItemDetail, isActive: $viewModel.goingDetail, shouldRefreshList: $viewModel.shouldRefreshList)
                        .onDisappear {
                            Task {
                                await viewModel.conditionalRefreshItemsList()
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
                viewModel.showItemFormView()
            } label: {
                addItemButton
            }
            .padding(25)
        }
        .fullScreenCover(isPresented: $viewModel.isAddingItem, content: {
            ItemFormView(isActive: $viewModel.isAddingItem, shouldRefreshList: $viewModel.shouldRefreshList)
                .onDisappear {
                    Task {
                        await viewModel.conditionalRefreshItemsList()
                    }
                }
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    Task {
                        await viewModel.refreshItemsList()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.delayingRefresh)
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
