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
    @State private var selection: Tab = .translate
    @Binding var isPresented: Bool
    var body: some View {
        
        TabView(selection: $selection) {
            TranslateView()
                .background(Color.myPurpleDark)
                .tabItem {
                    Image(systemName: "globe")
                    Text("Translate")
                }
                .tag(Tab.translate)

            DictionaryView()
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("Dictionary")
                }
                .tag(Tab.dictionary)
//
            StatisticView()
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Statistic")
                }
                .tag(Tab.statistic)
//
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Seting")
                }
                .tag(Tab.setting)

        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $lNManager.isPresented) {
            WordRememberView(vm: _vm,
                             word: vm.mostPopularWord ?? WordEntity())
       
        }
//        .onChange(of: selection) { newValue in
//
//                    print("TabSelection in Main: \(newValue)")
//
//        }
    }
}

enum Tab {
    case translate, dictionary, statistic, setting
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(isPresented: .constant(false))
            .environmentObject(DictViewModel(dataController: DataController()))
            .environmentObject(LocalNotificationManager(data: DataController()))
    }
}
