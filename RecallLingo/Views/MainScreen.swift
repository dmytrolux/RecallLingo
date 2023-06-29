//
//  MainScreen.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI
import Combine

struct MainScreen: View {
    var data = MyApp.dataController
    @EnvironmentObject var lNManager: LocalNotificationManager
    @State private var selection: Tab = .translate
    @Binding var isPresented: Bool
    
//    private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        
        TabView(selection: $selection) {
            TranslateView()
                .background(Color.myPurpleDark)
                .tabItem {
                    Image(systemName: "globe")
                    Text("tbTranslate")
                }
                .tag(Tab.translate)

            DictionaryView()
                .background(Color.myPurpleDark)
                .tabItem {
                    Image(systemName: selection == .dictionary ? "book" : "text.book.closed")
                    Text("tbDictionary")
                }
                .tag(Tab.dictionary)
//
            StatisticView()
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("tbStatistic")
                }
                .tag(Tab.statistic)
//
            SettingsView()
                .tabItem {
                    Image(systemName:  "gearshape")
                    Text("tbSetting")
                }
                .tag(Tab.setting)

        }
        .background(Color.myPurpleDark)
        .navigationViewStyle(.stack)
        .sheet(isPresented: $lNManager.isPresented) {
            WordRememberView(word: data.mostPopularWord())
       
        }
    }
    
    

    
    
}

enum Tab {
    case translate, dictionary, statistic, setting
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainScreen(isPresented: .constant(false))
//            .environmentObject(DictViewModel(dataController: DataController()))
//            .environmentObject(LocalNotificationManager(data: DataController()))
//    }
//}
