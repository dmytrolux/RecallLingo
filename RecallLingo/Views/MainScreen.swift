//
//  MainScreen.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var vm: DictViewModel
    @EnvironmentObject var lNManager: LocalNotificationManager
    @State private var selection = 0
    @Binding var isPresented: Bool
    var body: some View {
        
        TabView(selection: $selection) {
            TranslateView()
                .background(Color.myPurpleDark)
                .tabItem {
                    Image(systemName: "globe")
                    Text("Translate")
                }
                .tag(0)

            DictionaryView()
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("Dictionary")
                }
                .tag(1)
//
            StatisticView()
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Statistic")
                }
                .tag(2)
//
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Seting")
                }
                .tag(3)



        }
        .sheet(isPresented: $lNManager.isPresented) {
            WordRememberView(vm: _vm,
                             word: vm.mostPopularWord ?? WordEntity())
       
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(isPresented: .constant(false))
            .environmentObject(DictViewModel(dataController: DataController()))
            .environmentObject(LocalNotificationManager(data: DataController()))
    }
}
