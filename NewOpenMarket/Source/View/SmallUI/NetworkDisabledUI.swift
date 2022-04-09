//
//  NetworkDisabledUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/10.
//

import SwiftUI

struct NetworkDisabledUI: View {
    
    var body: some View {
        VStack(spacing: 50) {
            Image(systemName: "wifi.slash")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 120)
            Text("네트워크 상태가 좋지 않아요\n연결상태를 확인하고\n다시 시도해주세요 😉")
                .lineSpacing(10)
        }
        .font(.title)
    }
}
