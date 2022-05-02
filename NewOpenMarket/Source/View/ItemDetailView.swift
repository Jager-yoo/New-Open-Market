//
//  ItemDetailView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemDetailView: View {
    
    @StateObject private var viewModel: ItemDetailViewModel
    
    init(itemDetail: Item, isActive: Binding<Bool>, shouldRefreshList: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ItemDetailViewModel(itemDetail: itemDetail, isActive: isActive, shouldRefreshList: shouldRefreshList))
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offsetFromTop = geometry.frame(in: .global).minY
                let gap = offsetFromTop - (viewModel.statusBarHeight + 44) // 모든 device 에서 NavigationBar 높이가 전부 44pt 일까? (가정)
                
                // sticky image
                PageStyleImageViewer(itemImages: viewModel.itemDetail.images)
                    .frame(width: viewModel.screenWidth, height: viewModel.screenWidth + (gap > 0 ? gap : 0))
                    .offset(y: (gap > 0 ? -gap : 0))
            }
            .frame(minHeight: viewModel.screenWidth)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("(상품 번호 : \(viewModel.itemDetail.id.description))")
                    .foregroundColor(.secondary)
                ItemStockUI(itemStock: viewModel.itemDetail.stock)
                ItemPriceUI(item: viewModel.itemDetail)
                Text("게시자 : \(viewModel.itemDetail.vendor?.name ?? viewModel.placeholderText)")
                Text("업로드 날짜 : \(viewModel.itemDetail.createdAt.asDateOnly)")
                Divider()
                Text(viewModel.itemDetail.description ?? viewModel.placeholderText)
            }
            .padding()
        }
        .font(.title2)
        .navigationTitle("\(viewModel.itemDetail.name)")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.dismissSelf()
                } label: {
                    Image(systemName: "arrow.left")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isEditable {
                    Button {
                        viewModel.showDialog()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .onAppear {
            Task {
                // ItemSecret 을 찾을 수 있으면, 본인이 업로더이므로, 상품 수정 버튼이 활성화
                await viewModel.findItemSecret()
            }
        }
        .confirmationDialog("", isPresented: $viewModel.isShowingDialog) {
            dialogButtons
        }
        .alert("알림", isPresented: $viewModel.isShowingAlert) {
            Button {
                viewModel.isActive = false
            } label: {
                Text("리스트로 돌아가요")
            }
        } message: {
            Text("상품이 삭제됐어요")
        }
        .fullScreenCover(isPresented: $viewModel.isEditingItem, content: {
            ItemFormView(isActive: $viewModel.isEditingItem, editableItem: $viewModel.itemDetail, shouldRefreshList: $viewModel.shouldRefreshList)
        })
    }
    
    private var dialogButtons: some View {
        Group {
            Button {
                viewModel.isEditingItem = true
            } label: {
                Text("상품 수정")
            }
            
            Button(role: .destructive) {
                Task {
                    await viewModel.deleteItem()
                }
            } label: {
                Text("상품 삭제")
            }
            
            Button(role: .cancel) {
                viewModel.isShowingDialog = false
            } label: {
                Text("취소")
            }
        }
    }
}

private extension Date {
    
    private static let dateFormatter = DateFormatter()
    private static let defaultPreferredLanguage = "ko-KR"
    
    var asDateOnly: String {
        Self.dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? Self.defaultPreferredLanguage)
        Self.dateFormatter.dateStyle = .full
        return Self.dateFormatter.string(from: self)
    }
}
