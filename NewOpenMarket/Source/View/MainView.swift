//
//  MainView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import SwiftUI

struct MainView: View {
    
    @State private var listMode: Bool = true
    
    var body: some View {
        NavigationView {
            ItemsListView()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("", selection: $listMode) {
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
                                .tint(Color.primary)
                        }
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
