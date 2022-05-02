//
//  ItemDetailViewModel.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/05/02.
//

import SwiftUI

final class ItemDetailViewModel: ObservableObject {
    
    @Binding var isActive: Bool
    @Binding var shouldRefreshList: Bool
    @Published var itemDetail: Item
    @Published var isEditable: Bool = false
    @Published var isShowingDialog: Bool = false
    @Published var isShowingAlert: Bool = false
    @Published var isEditingItem: Bool = false
    @Published var itemSecret: String?
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height // FIXME: deprecated 되지 않은 버전으로 찾기!
    let placeholderText = "로딩 실패"
    
    init(itemDetail: Item, isActive: Binding<Bool>, shouldRefreshList: Binding<Bool>) {
        self.itemDetail = itemDetail
        self._isActive = isActive
        self._shouldRefreshList = shouldRefreshList
    }
    
    func findItemSecret() async {
        if let itemSecretData = try? await API.FindItemSecret(itemID: itemDetail.id).asyncExecute() {
            DispatchQueue.main.async {
                self.isEditable = true
                self.itemSecret = String(data: itemSecretData, encoding: .utf8)
            }
        }
    }
    
    func deleteItem() async {
        guard let itemSecret = itemSecret else {
            return
        }
        
        guard let deleteResponse = try? await API.DeleteItem(itemID: itemDetail.id, itemSecret: itemSecret).asyncExecute() else {
            return
        }
        
        guard deleteResponse.id == itemDetail.id else {
            return
        }
        
        DispatchQueue.main.async {
            self.isShowingAlert = true
            self.shouldRefreshList = true
        }
    }
    
    func showDialog() {
        isShowingDialog = true
        HapticManager.shared.selection()
    }
    
    func dismissSelf() {
        isActive = false
        HapticManager.shared.selection()
    }
}
