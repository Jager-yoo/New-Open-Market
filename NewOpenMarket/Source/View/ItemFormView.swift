//
//  ItemFormView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/15.
//

import SwiftUI

struct ItemFormView: View {
    
    var boundItem: Binding<Item>?
    @Binding var isActive: Bool
    @Binding var shouldRefreshList: Bool
    @FocusState private var isFocused: Field?
    @State private var images: [UIImage] = []
    @State private var isPicking: Bool = false
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemCurrency: Currency = .krw
    @State private var itemDiscount: String = ""
    @State private var itemStock: String = ""
    @State private var itemDescriptions: String = ""
    @State private var isSubmitting: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var itemAlerts: ItemAlert? {
        didSet {
            isShowingAlert = true // itemAlerts 를 할당하면 바로 Alert 자동으로 띄움
        }
    }
    let editMode: Bool
    
    /// ImagePicker 로 선택할 수 있는 최대 이미지 개수
    private static let imagesLimit: Int = 5
    private static let boxWidth: CGFloat = 100
    private static let boxCornerRadius: CGFloat = 10
    
    init(isActive: Binding<Bool>, editableItem: Binding<Item>? = nil, shouldRefreshList: Binding<Bool>) {
        self._isActive = isActive
        self._shouldRefreshList = shouldRefreshList
        
        guard let editableItem = editableItem, let uneditableImages = editableItem.wrappedValue.images else {
            editMode = false
            return
        }
        
        // 여기부터는 [상품 수정] 목적으로 사용할 경우
        editMode = true
        boundItem = editableItem
        
        let uneditableImagesData = uneditableImages.compactMap { try? Data(contentsOf: $0.thumbnailURL) }
        _images = State(wrappedValue: uneditableImagesData.compactMap { UIImage(data: $0) })
        _itemName = State(wrappedValue: editableItem.wrappedValue.name)
        _itemPrice = State(wrappedValue: editableItem.wrappedValue.price.asString)
        _itemCurrency = State(wrappedValue: editableItem.wrappedValue.currency)
        _itemDiscount = State(wrappedValue: editableItem.wrappedValue.discountedPrice.asString)
        _itemStock = State(wrappedValue: editableItem.wrappedValue.stock.description)
        _itemDescriptions = State(wrappedValue: editableItem.wrappedValue.description ?? "")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    imagesController
                    
                    TextField("상품 이름", text: $itemName)
                        .focused($isFocused, equals: .name)
                        .submitLabel(.next)
                        .onSubmit {
                            isFocused = .price
                        }
                    HStack {
                        TextField("상품 가격", text: $itemPrice)
                            .keyboardType(.numberPad)
                            .focused($isFocused, equals: .price)
                            .submitLabel(.next)
                        Picker("", selection: $itemCurrency) {
                            Text(Currency.krw.rawValue).tag(Currency.krw)
                            Text(Currency.usd.rawValue).tag(Currency.usd)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 120)
                    }
                    TextField("할인 금액", text: $itemDiscount)
                        .keyboardType(.numberPad)
                        .focused($isFocused, equals: .discount)
                    TextField("재고 수량", text: $itemStock)
                        .keyboardType(.numberPad)
                        .focused($isFocused, equals: .stock)
                    
                    TextEditorCustom(text: $itemDescriptions, placeholder: "상품에 대한 자세한 정보를 작성하면 판매확률이 올라가요!", textLimit: 1000, minHeight: 200)
                        .focused($isFocused, equals: .descriptions)
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            }
            .navigationTitle("상품 등록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isActive = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    submitButton
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    keyboardAddOn
                }
            }
        }
        .overlay {
            FullCoverProgressView(task: $isSubmitting, message: editMode ? "수정 중" : "등록 중")
        }
    }
    
    private var imagesController: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if editMode == false {
                    Button {
                        if images.count < Self.imagesLimit {
                            isPicking = true
                        } else {
                            itemAlerts = .imagesCountLimit
                        }
                    } label: {
                        addImageBox
                    }
                    .foregroundColor(.secondary)
                    .sheet(isPresented: $isPicking) {
                        ImagePicker(selectedImages: $images)
                    }
                }
                
                selectedImageBoxes
            }
            .padding(.top, 10)
        }
    }
    
    private var addImageBox: some View {
        Color.clear
            .frame(width: Self.boxWidth, height: Self.boxWidth)
            .overlay {
                VStack {
                    Image(systemName: "camera.fill")
                    Text("\(images.count)")
                        .foregroundColor(.orange)
                    + Text(" / \(Self.imagesLimit)")
                }
                .font(Font.system(size: 20))
            }
            .overlay {
                RoundedRectangle(cornerRadius: Self.boxCornerRadius)
                    .strokeBorder()
            }
    }
    
    private var selectedImageBoxes: some View {
        ForEach(images.indices, id: \.self) { index in
            Image(uiImage: images[index])
                .resizable()
                .scaledToFill()
                .frame(width: Self.boxWidth, height: Self.boxWidth)
                .cornerRadius(Self.boxCornerRadius)
                .overlay {
                    Button {
                        images.remove(at: index)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: Self.boxWidth / 5, height: Self.boxWidth / 5)
                    }
                    .offset(x: Self.boxWidth / 2, y: -Self.boxWidth / 2)
                    .disabled(editMode)
                }
        }
    }
    
    private var submitButton: some View {
        Button {
            isFocused = nil
            if validateItem() {
                Task {
                    editMode ? await editItem() : await addItem()
                }
            }
        } label: {
            Text("완료")
        }
        .alert("알림", isPresented: $isShowingAlert, presenting: itemAlerts) { alert in
            Button {
                if alert == .addItemSuccess || alert == .editItemSuccess {
                    isActive = false
                }
            } label: {
                Text(alert == .addItemSuccess || alert == .editItemSuccess ? "좋아요" : "알겠어요")
            }
        } message: { alert in
            Text(alert.message)
        }
    }
    
    private var keyboardAddOn: some View {
        HStack {
            Button {
                if isFocused?.rawValue == Field.first {
                    isFocused = nil
                } else {
                    isFocused = Field(rawValue: (isFocused?.rawValue ?? Field.first) - 1) // 실패하면 nil 할당
                }
            } label: {
                Image(systemName: "chevron.up")
            }
            
            Divider()
            
            Button {
                if isFocused?.rawValue == Field.last {
                    isFocused = nil
                } else {
                    isFocused = Field(rawValue: (isFocused?.rawValue ?? Field.last) + 1) // 실패하면 nil 할당
                }
            } label: {
                Image(systemName: "chevron.down")
            }
            
            Spacer()
            
            Button {
                isFocused = nil
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }
    
    private func addItem() async {
        do {
            isSubmitting = true
            _ = try await API.AddItem(
                images: images,
                name: itemName,
                descriptions: itemDescriptions,
                currency: itemCurrency,
                price: itemPrice,
                discount: itemDiscount,
                stock: itemStock
            ).asyncExecute()
            itemAlerts = .addItemSuccess
            shouldRefreshList = true // ListView 에 성공 여부 알림
            isSubmitting = false
        } catch {
            print("⚠️ AddItem 통신 중 에러 발생! -> \(error)")
            itemAlerts = .addItemFail
            isSubmitting = false
        }
    }
    
    private func editItem() async {
        guard let editableItem = boundItem else {
            return
        }
        
        do {
            isSubmitting = true
            let editedItem = try await API.EditItem(
                itemID: editableItem.id,
                name: itemName,
                descriptions: itemDescriptions,
                currency: itemCurrency,
                price: itemPrice,
                discount: itemDiscount,
                stock: itemStock
            ).asyncExecute()
            itemAlerts = .editItemSuccess
            shouldRefreshList = true
            isSubmitting = false
            boundItem?.wrappedValue = editedItem // 모달 뒤에 있는 ItemDetailView 수정
        } catch {
            print("⚠️ EditItem 통신 중 에러 발생! -> \(error)")
            itemAlerts = .editItemFail
            isSubmitting = false
        }
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
}

private extension ItemFormView {
    
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
    
    enum ItemAlert {
        
        case emptyImages
        case imagesCountLimit
        case invalidName
        case invalidPrice
        case invalidDiscount
        case invalidDescriptions
        case addItemFail
        case addItemSuccess
        case editItemFail
        case editItemSuccess
        
        var message: String {
            switch self {
            case .emptyImages:
                return "이미지는 최소 1장 첨부해주세요"
            case .imagesCountLimit:
                return "이미지는 최대 \(imagesLimit)장까지 첨부할 수 있어요 😅"
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

struct ItemAddView_Previews: PreviewProvider {
    static var previews: some View {
        ItemFormView(isActive: .constant(true), shouldRefreshList: .constant(false))
    }
}
