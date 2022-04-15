//
//  ItemAddView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/15.
//

import SwiftUI

struct ItemAddView: View {
    
    @Binding var isActive: Bool
    @State private var isPicking: Bool = false
    @State private var images: [UIImage] = []
    @State private var isReachedImagesLimit: Bool = false
    
    /// ImagePicker 로 선택할 수 있는 최대 이미지 개수
    private static let imagesLimit = 5
    
    var body: some View {
        NavigationView {
            ScrollView {
                imagesController
                
                Divider()
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
                    Text("완료")
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
                    addImageButton
                }
                .foregroundColor(.secondary)
                .sheet(isPresented: $isPicking) {
                    ImagePicker(selectedImages: $images)
                }
                .alert(isPresented: $isReachedImagesLimit) {
                    AlertManager.imagesCountReached(Self.imagesLimit)
                }
                
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private var addImageButton: some View {
        Color.clear
            .frame(width: 100, height: 100)
            .overlay {
                VStack {
                    Image(systemName: "camera.fill")
                    Text("\(images.count)")
                        .foregroundColor(.orange)
                    + Text(" / \(Self.imagesLimit)")
                }
                .font(.title3)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder()
            }
    }
}

struct ItemAddView_Previews: PreviewProvider {
    static var previews: some View {
        ItemAddView(isActive: .constant(true))
    }
}
