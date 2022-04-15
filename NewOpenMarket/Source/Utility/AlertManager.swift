//
//  AlertManager.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/16.
//

import SwiftUI

enum AlertManager {
    
    static func imagesCountReached(_ limit: Int) -> Alert {
        Alert(
            title: Text("알림"),
            message: Text("이미지는 최대 \(limit)장까지 첨부할 수 있어요 😅"),
            dismissButton: .default(Text("알겠어요"))
        )
    }
}
