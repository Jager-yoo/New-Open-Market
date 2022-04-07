//
//  MainView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        NavigationView {
            ItemsListView()
                .navigationTitle("뉴 오픈 마켓!")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            print("리스트 버튼 눌림!")
                        } label: {
                            Image(systemName: "rectangle.grid.1x2")
                        }

                        Button {
                            print("그리드 버튼 눌림!")
                        } label: {
                            Image(systemName: "rectangle.grid.2x2")
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            print("설정 버튼 눌림!")
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .tint(Color.primary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            
    }
}
