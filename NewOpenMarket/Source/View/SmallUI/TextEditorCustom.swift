//
//  TextEditorCustom.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/16.
//

import SwiftUI

struct TextEditorCustom: View {
    
    @Binding var text: String
    let placeholder: String
    let textLimit: Int
    let minHeight: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(Color(uiColor: .separator), lineWidth: 0.5)
                    }
                
                Text(placeholder + text)
                    .foregroundColor(Color(uiColor: .placeholderText))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 8)
                    .allowsHitTesting(false)
                    .opacity(text.isEmpty ? 1 : 0)
            }
            .frame(minHeight: minHeight)
            
            Group {
                if text.count <= textLimit {
                    Text("\(text.count) / \(textLimit)")
                } else {
                    Text("\(text.count)")
                        .foregroundColor(.red)
                    + Text(" / \(textLimit)")
                }
            }
            .font(.footnote)
            .foregroundColor(Color(uiColor: .placeholderText))
        }
    }
}
