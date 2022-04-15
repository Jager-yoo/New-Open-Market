//
//  ItemAddView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/15.
//

import SwiftUI

struct ItemAddView: View {
    
    @Binding var isActive: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal) {
                    Button {
                        print("📸 이미지 추가 버튼 눌림!")
                    } label: {
                        Color.clear
                            .frame(width: 100, height: 100)
                            .overlay {
                                VStack {
                                    Image(systemName: "camera.fill")
                                    Text("1 / 5")
                                }
                                .font(.title3)
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder()
                            }
                    }
                    .foregroundColor(.secondary)
                    
                    // 추가되는 이미지들
                    
                }
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
