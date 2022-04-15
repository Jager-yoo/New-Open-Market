//
//  AddItemButtonUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/15.
//

import SwiftUI

struct AddItemButtonUI: View {
    
    var body: some View {
        Circle()
            .fill(.orange)
            .frame(width: 70, height: 70)
            .shadow(radius: 3)
            .overlay {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(.white)
                    .padding(20)
            }
            .padding()
    }
}
