//
//  MainView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isServerOn {
                    ItemsListView()
                } else {
                    NetworkDisabledUI()
                }
            } // if문으로 화면이 분기된 구조를 Group 으로 묶으면, modifier 적용할 수 있음!
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $viewModel.listMode) {
                        Image(systemName: "rectangle.grid.1x2").tag(true)
                        Image(systemName: "rectangle.grid.2x2").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 180)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("설정 버튼 눌림!")
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.checkServerStatus()
        }
    }
}

private extension MainView {
    
    final class MainViewModel: ObservableObject {
        
        @Published var listMode: Bool = true
        @Published var isServerOn: Bool = true
        
        func checkServerStatus() async {
            do {
                let message = try await API.HealthChecker().asyncExecute()
                DispatchQueue.main.async { [weak self] in
                    self?.isServerOn = (message == "OK")
                }
            } catch {
                print("⚠️ HealthChecker 통신 중 에러 발생! -> \(error.localizedDescription)")
                DispatchQueue.main.async { [weak self] in
                    self?.isServerOn = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
