//
//  ItemAddView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/15.
//

import SwiftUI

struct ItemAddView: View {
    
    @Binding var isActive: Bool
    @State private var images: [UIImage] = []
    @State private var isPicking: Bool = false
    @State private var isReachedImagesLimit: Bool = false
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemCurrency: Currency = .krw
    @State private var itemDiscount: String = ""
    @State private var itemStock: String = ""
    @State private var itemDescriptions: String = ""
    @State private var isShowingAlert: ItemAlert?
    @FocusState private var isFocused: Field?
    
    /// ImagePicker 로 선택할 수 있는 최대 이미지 개수
    private static let imagesLimit: Int = 5
    private static let boxWidth: CGFloat = 100
    private static let boxCornerRadius: CGFloat = 10
    
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
                    
                    TextEditorWithPlaceholder(text: $itemDescriptions, placeholder: "상품에 대한 자세한 정보를 작성하면 판매확률이 올라가요!", minHeight: 250)
                        .focused($isFocused, equals: .descriptions)
                }
                .textFieldStyle(.roundedBorder)
                .padding()
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
                    Button {
                        if images.isEmpty {
                            isShowingAlert = .emptyImages
                        } else if !(3...100).contains(itemName.count) {
                            isShowingAlert = .invalidName
                            isFocused = .name
                        } else if itemPrice.isEmpty {
                            isShowingAlert = .invalidPrice
                            isFocused = .price
                        } else if Int(itemDiscount) ?? .zero > Int(itemPrice)! {
                            isShowingAlert = .invalidDiscount
                            itemDiscount = ""
                            isFocused = .discount
                        } else if !(10...1000).contains(itemDescriptions.count) {
                            isShowingAlert = .invalidDescriptions
                            isFocused = .descriptions
                        }
                    } label: {
                        Text("완료")
                    }
                    .alert(using: $isShowingAlert) { alert in
                        alert.show
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    keyboardAddOn
                }
            }
        }
    }
    
    private var imagesController: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    if images.count < Self.imagesLimit {
                        isPicking = true
                    } else {
                        isReachedImagesLimit = true
                    }
                } label: {
                    addImageBox
                }
                .foregroundColor(.secondary)
                .sheet(isPresented: $isPicking) {
                    ImagePicker(selectedImages: $images)
                }
                .alert(isPresented: $isReachedImagesLimit) {
                    Alert(
                        title: Text("알림"),
                        message: Text("이미지는 최대 \(Self.imagesLimit)장까지 첨부할 수 있어요 😅"),
                        dismissButton: .default(Text("알겠어요"))
                    )
                }
                
                selectedImageBoxes
            }
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
                }
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
}

private extension ItemAddView {
    
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
        case invalidName
        case invalidPrice
        case invalidDiscount
        case invalidDescriptions
        
        var show: Alert {
            switch self {
            case .emptyImages:
                return Alert(
                    title: Text("알림"),
                    message: Text("이미지는 최소 1장 첨부해주세요"),
                    dismissButton: .default(Text("알겠어요"))
                )
            case .invalidName:
                return Alert(
                    title: Text("알림"),
                    message: Text("상품 이름은 3 ~ 100 글자 사이로 입력해주세요"),
                    dismissButton: .default(Text("알겠어요"))
                )
            case .invalidPrice:
                return Alert(
                    title: Text("알림"),
                    message: Text("상품 가격을 입력해주세요"),
                    dismissButton: .default(Text("알겠어요"))
                )
            case .invalidDiscount:
                return Alert(
                    title: Text("알림"),
                    message: Text("할인가는 가격을 초과할 수 없어요"),
                    dismissButton: .default(Text("알겠어요"))
                )
            case .invalidDescriptions:
                return Alert(
                    title: Text("알림"),
                    message: Text("상품 정보는 10 ~ 1,000 글자 사이로 입력해주세요"),
                    dismissButton: .default(Text("알겠어요"))
                )
            }
        }
    }
}

private extension View {
    
    func alert<Value>(using value: Binding<Value?>, content: (Value) -> Alert) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        
        return alert(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }
}

struct ItemAddView_Previews: PreviewProvider {
    static var previews: some View {
        ItemAddView(isActive: .constant(true))
    }
}
