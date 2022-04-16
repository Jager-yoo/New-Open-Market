//
//  TextEditorWithPlaceholder.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/16.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color(uiColor: .separator), lineWidth: 0.5)
                }
            
            Text(placeholder)
                .foregroundColor(Color(uiColor: .placeholderText))
                .padding(.horizontal, 6)
                .padding(.vertical, 8)
                .allowsHitTesting(false)
                .opacity(text.isEmpty ? 1 : 0)
        }
        .frame(minHeight: minHeight)
    }
}
