//
//  FullCoverProgressUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/21.
//

import SwiftUI

struct FullCoverProgressUI: View {
    
    @Binding var task: Bool
    let message: String
    
    var body: some View {
        if task {
            ZStack {
                Color(uiColor: .secondarySystemBackground)
                    .opacity(0.5)
                    .ignoresSafeArea()
                ProgressView(message)
                    .scaleEffect(1.5)
            }
        }
    }
}

struct FullCoverProgressUI_Previews: PreviewProvider {
    static var previews: some View {
        FullCoverProgressUI(task: .constant(true), message: "등록 중")
    }
}
