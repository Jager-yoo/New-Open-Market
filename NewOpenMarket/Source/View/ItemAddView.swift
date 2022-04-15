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
    
    private static let maxImagesLimit = 5
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button {
                            isPicking = true
                        } label: {
                            Color.clear
                                .frame(width: 100, height: 100)
                                .overlay {
                                    VStack {
                                        Image(systemName: "camera.fill")
                                        Text("\(images.count)")
                                            .foregroundColor(.orange)
                                        + Text(" / \(Self.maxImagesLimit)")
                                    }
                                    .font(.title3)
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder()
                                }
                        }
                        .foregroundColor(.secondary)
                        .sheet(isPresented: $isPicking) {
                            ImagePicker(selectedImages: $images)
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
}

struct ItemAddView_Previews: PreviewProvider {
    static var previews: some View {
        ItemAddView(isActive: .constant(true))
    }
}
