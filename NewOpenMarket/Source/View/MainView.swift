//
//  MainView.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/06.
//

import SwiftUI

struct MainView: View {
    
    @State private var isServerOn: Bool = true
    @State private var isSetting: Bool = false
    
    var body: some View {
        NavigationView {
            Group {
                if isServerOn {
                    ItemsListView()
                } else {
                    ErrorUI()
                }
            } // if문으로 화면이 분기된 구조를 Group 으로 묶으면, modifier 적용할 수 있음!
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSetting = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .navigationTitle("스유 마켓 🥕")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await checkServerStatus()
        }
        .sheet(isPresented: $isSetting) {
            // TODO: 다크 모드, 햅틱 구현하기
            Text("여기에서 다크 모드/햅틱을 켜고 끌 수 있습니다.")
                .font(.largeTitle)
        }
    }
    
    private func checkServerStatus() async {
        do {
            let message = try await API.HealthChecker().asyncExecute()
            isServerOn = (message == "OK")
        } catch {
            print("⚠️ HealthChecker 통신 중 에러 발생! -> \(error.localizedDescription)")
            isServerOn = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
