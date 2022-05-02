//
//  SettingsView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/28.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel: SettingsViewModel
    
    init(isActive: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(isActive: isActive))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(viewModel.isDarkMode ? "다크 모드 켜짐" : "다크 모드 꺼짐", isOn: $viewModel.isDarkMode)
                } header: {
                    Text("디스플레이")
                }
                
                Section {
                    Toggle(viewModel.isHapticOn ? "진동 켜짐" : "진동 꺼짐", isOn: $viewModel.isHapticOn)
                } header: {
                    Text("햅틱 피드백")
                }
            }
            .navigationTitle("설정")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        viewModel.dismissSelf()
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
