//
//  ItemDetailView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/08.
//

import SwiftUI

struct ItemDetailView: View {
    
    @State private var isEditable: Bool = false
    @State private var isShowingSheet: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var isEditingItem: Bool = false
    @State private var itemSecret: String?
    @Binding var isActive: Bool
    @Binding var shouldRefreshList: Bool
    let itemDetail: Item
    
    private static let placeholderText = "로딩 실패"
    
    var body: some View {
        ScrollView {
            PageStyleImageViewerUI(itemImages: itemDetail.images)
            
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
        .toolbar {
            if isEditable {
                Button {
                    isShowingSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
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
        .fullScreenCover(isPresented: $isEditingItem, onDismiss: {
            // 모달 내려갈 때 액션
            // ItemDetailView 내용을 갱신해야 겠는데...?
            // 근데 그럴거면 아예, 구조체를 다시 구성해야 할텐데?
            // 쉬운 루트 -> List 로 내보내고 리프레시
            // 어려운 루트 -> ItemDetailView 리프레시
        }, content: {
            ItemAddView(isActive: $isEditingItem, shouldRefreshList: $shouldRefreshList)
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
