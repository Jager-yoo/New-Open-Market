//
//  ErrorUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/10.
//

import SwiftUI

struct ErrorUI: View {
    
    var body: some View {
        VStack(spacing: 50) {
            Image(systemName: "xmark.octagon")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 100)
            Text("에러가 발생했어요 😅\n다시 시도하거나\n개발자에게 문의해주세요")
                .lineSpacing(10)
                .multilineTextAlignment(.center) // \n 으로 구분한 여러 줄의 Text 의 alignment 조정하는 modifier
        }
        .font(.title)
        .foregroundColor(.secondary)
    }
}

struct ErrorUI_Previews: PreviewProvider {
    static var previews: some View {
        ErrorUI()
    }
}
