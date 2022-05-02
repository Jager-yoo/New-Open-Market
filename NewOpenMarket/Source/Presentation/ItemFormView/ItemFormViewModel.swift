//
//  ItemFormViewModel.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/05/02.
//

import SwiftUI

final class ItemFormViewModel: ObservableObject {
    
    let editMode: Bool
    var boundItem: Binding<Item>?
    @Binding var isActive: Bool
    @Binding var shouldRefreshList: Bool
    @Published var images: [UIImage] = []
    @Published var isPicking: Bool = false
    @Published var itemName: String = ""
    @Published var itemPrice: String = ""
    @Published var itemCurrency: Currency = .krw
    @Published var itemDiscount: String = ""
    @Published var itemStock: String = ""
    @Published var itemDescriptions: String = ""
    @Published var isSubmitting: Bool = false
    @Published var isShowingAlert: Bool = false
    @Published var itemAlerts: ItemAlert? {
        didSet {
            DispatchQueue.main.async {
                self.isShowingAlert = true // itemAlerts 를 할당하면 바로 Alert 자동으로 띄움
            }
        }
    }
    @Published var isFocused: Field?
    
    /// ImagePicker 로 선택할 수 있는 최대 이미지 개수
    let imagesLimit: Int = 5
    let boxWidth: CGFloat = 100
    let boxCornerRadius: CGFloat = 10
    
    init(isActive: Binding<Bool>, editableItem: Binding<Item>? = nil, shouldRefreshList: Binding<Bool>) {
        self._isActive = isActive
        self._shouldRefreshList = shouldRefreshList
        
        guard let editableItem = editableItem,
              let uneditableImages = editableItem.wrappedValue.images else {
            editMode = false
            return
        }
        
        // 여기부터는 [상품 수정] 목적으로 사용할 경우
        editMode = true
        boundItem = editableItem
        
        let uneditableImagesData = uneditableImages.compactMap { try? Data(contentsOf: $0.thumbnailURL) }
        _images = Published(wrappedValue: uneditableImagesData.compactMap { UIImage(data: $0) })
        _itemName = Published(wrappedValue: editableItem.wrappedValue.name)
        _itemPrice = Published(wrappedValue: editableItem.wrappedValue.price.asString)
        _itemCurrency = Published(wrappedValue: editableItem.wrappedValue.currency)
        _itemDiscount = Published(wrappedValue: editableItem.wrappedValue.discountedPrice.asString)
        _itemStock = Published(wrappedValue: editableItem.wrappedValue.stock.description)
        _itemDescriptions = Published(wrappedValue: editableItem.wrappedValue.description ?? "")
    }
    
    func addItem() async {
        do {
            DispatchQueue.main.async {
                self.isSubmitting = true
            }
            _ = try await API.AddItem(
                images: images,
                name: itemName,
                descriptions: itemDescriptions,
                currency: itemCurrency,
                price: itemPrice,
                discount: itemDiscount,
                stock: itemStock
            ).asyncExecute()
            DispatchQueue.main.async {
                self.itemAlerts = .addItemSuccess
                self.shouldRefreshList = true // ListView 에 성공 여부 알림
                self.isSubmitting = false
            }
        } catch {
            print("⚠️ AddItem 통신 중 에러 발생! -> \(error)")
            DispatchQueue.main.async {
                self.itemAlerts = .addItemFail
                self.isSubmitting = false
            }
        }
    }
    
    func editItem() async {
        guard let editableItem = boundItem else {
            return
        }
        
        do {
            DispatchQueue.main.async {
                self.isSubmitting = true
            }
            let editedItem = try await API.EditItem(
                itemID: editableItem.id,
                name: itemName,
                descriptions: itemDescriptions,
                currency: itemCurrency,
                price: itemPrice,
                discount: itemDiscount,
                stock: itemStock
            ).asyncExecute()
            DispatchQueue.main.async {
                self.itemAlerts = .editItemSuccess
                self.shouldRefreshList = true
                self.isSubmitting = false
                self.boundItem?.wrappedValue = editedItem // 모달 뒤에 있는 ItemDetailView 수정
            }
        } catch {
            print("⚠️ EditItem 통신 중 에러 발생! -> \(error)")
            DispatchQueue.main.async {
                self.itemAlerts = .editItemFail
                self.isSubmitting = false
            }
        }
    }
    
    func submitItem() {
        dismissKeyboard()
        if validateItem() {
            Task {
                editMode ? await editItem() : await addItem()
            }
        }
        HapticManager.shared.selection()
    }
    
    private func validateItem() -> Bool {
        if images.isEmpty {
            itemAlerts = .emptyImages
            return false
        } else if !(3...100).contains(itemName.count) {
            itemAlerts = .invalidName
            isFocused = .name
            return false
        } else if itemPrice.isEmpty {
            itemAlerts = .invalidPrice
            isFocused = .price
            return false
        } else if Double(itemDiscount) ?? .zero > Double(itemPrice) ?? .zero {
            itemAlerts = .invalidDiscount
            itemDiscount = ""
            isFocused = .discount
            return false
        } else if !(10...1000).contains(itemDescriptions.count) {
            itemAlerts = .invalidDescriptions
            isFocused = .descriptions
            return false
        }
        
        return true
    }
    
    func activateImagePicker() {
        if images.count < imagesLimit {
            isPicking = true
        } else {
            itemAlerts = .imagesCountLimit(imagesLimit)
        }
        HapticManager.shared.selection()
    }
    
    func removeImage(at index: Int) {
        images.remove(at: index)
        HapticManager.shared.selection()
    }
    
    func controlAlerts(_ alert: ItemAlert) {
        if alert.isSucess {
            isActive = false
        }
    }
    
    func focusOn(_ field: Field) {
        isFocused = field
    }
    
    func dismissKeyboard() {
        isFocused = nil
    }
    
    func focusUp() {
        if isFocused?.rawValue == Field.first {
            isFocused = nil
        } else {
            isFocused = Field(rawValue: (isFocused?.rawValue ?? Field.first) - 1) // 실패하면 nil 할당
        }
    }
    
    func focusDown() {
        if isFocused?.rawValue == Field.last {
            isFocused = nil
        } else {
            isFocused = Field(rawValue: (isFocused?.rawValue ?? Field.last) + 1) // 실패하면 nil 할당
        }
    }
    
    func dismissSelf() {
        isActive = false
        HapticManager.shared.selection()
    }
}

extension ItemFormViewModel {
    
    enum Field: Int, CaseIterable, Hashable {
        
        case name
        case price
        case discount
        case stock
        case descriptions
        
        static var first: Int {
            .zero
        }
        
        static var last: Int {
            Self.allCases.count - 1
        }
    }
    
    enum ItemAlert: Equatable {
        
        case emptyImages
        case imagesCountLimit(_ limit: Int)
        case invalidName
        case invalidPrice
        case invalidDiscount
        case invalidDescriptions
        case addItemFail
        case addItemSuccess
        case editItemFail
        case editItemSuccess
        
        var isSucess: Bool {
            let successAlerts: [ItemAlert] = [.addItemSuccess, .editItemSuccess]
            return successAlerts.contains(self)
        }
        
        var message: String {
            switch self {
            case .emptyImages:
                return "이미지는 최소 1장 첨부해주세요"
            case .imagesCountLimit(let limit):
                return "이미지는 최대 \(limit)장까지 첨부할 수 있어요 😅"
            case .invalidName:
                return "상품 이름은 3 ~ 100 글자 사이로 입력해주세요"
            case .invalidPrice:
                return "상품 가격을 입력해주세요"
            case .invalidDiscount:
                return "할인가는 가격을 초과할 수 없어요"
            case .invalidDescriptions:
                return "상품 정보는 10 ~ 1,000 글자 사이로 입력해주세요"
            case .addItemFail:
                return "상품 등록에 실패했습니다 🥲"
            case .addItemSuccess:
                return "상품이 성공적으로 등록됐습니다 🥰"
            case .editItemFail:
                return "상품 수정에 실패했습니다 🥲"
            case .editItemSuccess:
                return "상품이 성공적으로 수정됐습니다 🥰"
            }
        }
    }
}
