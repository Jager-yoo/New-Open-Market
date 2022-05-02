//
//  ItemFormView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/15.
//

import SwiftUI

struct ItemFormView: View {
    
    @StateObject private var viewModel: ItemFormViewModel
    @FocusState private var isFocused: ItemFormViewModel.Field?
    
    init(isActive: Binding<Bool>, editableItem: Binding<Item>? = nil, shouldRefreshList: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ItemFormViewModel(isActive: isActive, editableItem: editableItem, shouldRefreshList: shouldRefreshList))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    imagesController
                    
                    itemInformationFields
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)            }
            .navigationTitle("상품 등록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        viewModel.dismissSelf()
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
            FullCoverProgressView(task: $viewModel.isSubmitting, message: viewModel.editMode ? "수정 중" : "등록 중")
        }
    }
    
    private var itemInformationFields: some View {
        Group {
            TextField("상품 이름", text: $viewModel.itemName)
                .submitLabel(.next)
                .onSubmit {
                    viewModel.focusOn(.price)
                }
                .focused($isFocused, equals: .name)
            
            HStack {
                TextField("상품 가격", text: $viewModel.itemPrice)
                    .keyboardType(.numberPad)
                    .focused($isFocused, equals: .price)
                
                Picker("", selection: $viewModel.itemCurrency) {
                    Text(Currency.krw.rawValue).tag(Currency.krw)
                    Text(Currency.usd.rawValue).tag(Currency.usd)
                }
                .pickerStyle(.segmented)
                .frame(width: 120)
            }
            
            TextField("할인 금액", text: $viewModel.itemDiscount)
                .keyboardType(.numberPad)
                .focused($isFocused, equals: .discount)
            
            TextField("재고 수량", text: $viewModel.itemStock)
                .keyboardType(.numberPad)
                .focused($isFocused, equals: .stock)
            
            TextEditorCustom(text: $viewModel.itemDescriptions, placeholder: "상품에 대한 자세한 정보를 작성하면 판매확률이 올라가요!", textLimit: 1000, minHeight: 200)
                .focused($isFocused, equals: .descriptions)
        }
        .onChange(of: viewModel.isFocused) { newValue in
            self.isFocused = newValue
        }
        .onChange(of: self.isFocused) { newValue in
            viewModel.isFocused = newValue
        }
    }
    
    private var imagesController: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if viewModel.editMode == false {
                    Button {
                        viewModel.activateImagePicker()
                    } label: {
                        addImageBox
                    }
                    .foregroundColor(.secondary)
                    .sheet(isPresented: $viewModel.isPicking) {
                        ImagePicker(selectedImages: $viewModel.images)
                    }
                }
                
                selectedImageBoxes
            }
            .padding(.top, 10)
        }
    }
    
    private var addImageBox: some View {
        Color.clear
            .frame(width: viewModel.boxWidth, height: viewModel.boxWidth)
            .overlay {
                VStack {
                    Image(systemName: "camera.fill")
                    Text("\(viewModel.images.count)")
                        .foregroundColor(.orange)
                    + Text(" / \(viewModel.imagesLimit)")
                }
                .font(Font.system(size: 20))
            }
            .overlay {
                RoundedRectangle(cornerRadius: viewModel.boxCornerRadius)
                    .strokeBorder()
            }
    }
    
    private var selectedImageBoxes: some View {
        ForEach(viewModel.images.indices, id: \.self) { index in
            Image(uiImage: viewModel.images[index])
                .resizable()
                .scaledToFill()
                .frame(width: viewModel.boxWidth, height: viewModel.boxWidth)
                .cornerRadius(viewModel.boxCornerRadius)
                .overlay {
                    Button {
                        viewModel.removeImage(at: index)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: viewModel.boxWidth / 5, height: viewModel.boxWidth / 5)
                    }
                    .offset(x: viewModel.boxWidth / 2, y: -viewModel.boxWidth / 2)
                    .disabled(viewModel.editMode)
                }
        }
    }
    
    private var submitButton: some View {
        Button {
            viewModel.submitItem()
        } label: {
            Text("완료")
        }
        .alert("알림", isPresented: $viewModel.isShowingAlert, presenting: viewModel.itemAlerts) { alert in
            Button {
                viewModel.controlAlerts(alert)
            } label: {
                Text(alert.isSucess ? "좋아요" : "알겠어요")
            }
        } message: { alert in
            Text(alert.message)
        }
    }
    
    private var keyboardAddOn: some View {
        HStack {
            Button {
                viewModel.focusUp()
            } label: {
                Image(systemName: "chevron.up")
            }
            
            Divider()
            
            Button {
                viewModel.focusDown()
            } label: {
                Image(systemName: "chevron.down")
            }
            
            Spacer()
            
            Button {
                viewModel.dismissKeyboard()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }
}

struct ItemAddView_Previews: PreviewProvider {
    static var previews: some View {
        ItemFormView(isActive: .constant(true), shouldRefreshList: .constant(false))
    }
}
