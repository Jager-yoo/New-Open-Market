//
//  MainViewModel.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/05/02.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published var isServerOn: Bool = true
    @Published var isSetting: Bool = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    func checkServerStatus() async {
        do {
            let message = try await API.HealthChecker().asyncExecute()
            DispatchQueue.main.async {
                self.isServerOn = (message == "OK")
            }
        } catch {
            print("⚠️ HealthChecker 통신 중 에러 발생! -> \(error)")
            DispatchQueue.main.async {
                self.isServerOn = false
            }
        }
    }
    
    func showSettingsView() {
        isSetting = true
        HapticManager.shared.selection()
    }
}
