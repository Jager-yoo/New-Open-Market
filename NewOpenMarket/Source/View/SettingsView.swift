//
//  SettingsView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/28.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isActive: Bool
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isHapticOn") private var isHapticOn: Bool = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isDarkMode ? "다크 모드 켜짐" : "다크 모드 꺼짐", isOn: $isDarkMode)
                } header: {
                    Text("디스플레이")
                }
                
                Section {
                    Toggle(isHapticOn ? "진동 켜짐" : "진동 꺼짐", isOn: $isHapticOn)
                } header: {
                    Text("햅틱 피드백")
                }
            }
            .navigationTitle("설정")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isActive = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isActive: .constant(true))
    }
}
