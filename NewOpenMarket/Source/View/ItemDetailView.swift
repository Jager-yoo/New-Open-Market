//
//  ItemDetailView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemDetailView: View {
    
    @State var itemDetail: Item
    @Binding var isActive: Bool
    @Binding var shouldRefreshList: Bool
    @State private var isEditable: Bool = false
    @State private var isShowingSheet: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var isEditingItem: Bool = false
    @State private var itemSecret: String?
    
    private static let screenWidth: CGFloat = UIScreen.main.bounds.width
    private static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height // FIXME: deprecated 되지 않은 버전으로 찾기!
    private static let placeholderText = "로딩 실패"
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offsetFromTop = geometry.frame(in: .global).minY
                let gap = offsetFromTop - (Self.statusBarHeight + 44) // 모든 device 에서 NavigationBar 높이가 전부 44pt 일까? (가정)
                
                // sticky image
                PageStyleImageViewer(itemImages: itemDetail.images)
                    .frame(width: Self.screenWidth, height: Self.screenWidth + (gap > 0 ? gap : 0))
                    .offset(y: (gap > 0 ? -gap : 0))
            }
            .frame(minHeight: Self.screenWidth)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("(상품 번호 : \(itemDetail.id.description))")
                    .foregroundColor(.secondary)
                ItemStockUI(itemStock: itemDetail.stock)
                ItemPriceUI(item: itemDetail)
                Text("게시자 : \(itemDetail.vendor?.name ?? Self.placeholderText)")
                Text("업로드 날짜 : \(itemDetail.createdAt.asDateOnly)")
                Divider()
                Text(itemDetail.description ?? Self.placeholderText)
            }
            .padding()
        }
        .font(.title2)
        .navigationTitle("\(itemDetail.name)")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isActive = false
                    HapticManager.shared.selection()
                } label: {
                    Image(systemName: "arrow.left")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditable {
                    Button {
                        isShowingSheet = true
                        HapticManager.shared.selection()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .onAppear {
            Task {
                // ItemSecret 을 찾을 수 있으면, 본인이 업로더이므로, 상품 수정 버튼이 활성화
                if let itemSecretData = try? await API.FindItemSecret(itemID: itemDetail.id).asyncExecute() {
                    isEditable = true
                    itemSecret = String(data: itemSecretData, encoding: .utf8)
                }
            }
        }
        .confirmationDialog("", isPresented: $isShowingSheet) {
            sheetButtons
        }
        .alert("알림", isPresented: $isShowingAlert) {
            Button {
                isActive = false
                shouldRefreshList = true
            } label: {
                Text("리스트로 돌아가요")
            }
        } message: {
            Text("상품이 삭제됐어요")
        }
        .fullScreenCover(isPresented: $isEditingItem, content: {
            ItemFormView(isActive: $isEditingItem, editableItem: $itemDetail, shouldRefreshList: $shouldRefreshList)
        })
    }
    
    private var sheetButtons: some View {
        Group {
            Button {
                isEditingItem = true
            } label: {
                Text("상품 수정")
            }
            
            Button(role: .destructive) {
                Task {
                    guard let itemSecret = itemSecret else {
                        return
                    }
                    
                    let deleteResponse = try await API.DeleteItem(itemID: itemDetail.id, itemSecret: itemSecret).asyncExecute()
                    
                    guard deleteResponse.id == itemDetail.id else {
                        return
                    }
                    
                    isShowingAlert = true
                }
            } label: {
                Text("상품 삭제")
            }
            
            Button(role: .cancel) {
                isShowingSheet = false
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
