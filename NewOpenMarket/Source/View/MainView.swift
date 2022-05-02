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
                    ErrorView()
                }
            } // if문으로 화면이 분기된 구조를 Group 으로 묶으면, modifier 적용할 수 있음!
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showSettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .navigationTitle("스유 마켓 🥕")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.checkServerStatus()
        }
        .sheet(isPresented: $viewModel.isSetting) {
            SettingsView(isActive: $viewModel.isSetting)
                .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
