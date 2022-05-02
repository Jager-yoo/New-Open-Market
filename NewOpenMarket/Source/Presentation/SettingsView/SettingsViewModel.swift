//
//  SettingsViewModel.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/05/02.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @Binding var isActive: Bool
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("isHapticOn") var isHapticOn: Bool = true
    
    init(isActive: Binding<Bool>) {
        _isActive = isActive
    }
    
    func dismissSelf() {
        isActive = false
        HapticManager.shared.selection()
    }
}
