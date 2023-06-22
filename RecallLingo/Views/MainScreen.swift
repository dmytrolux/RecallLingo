//
//  MainScreen.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

struct MainScreen: View {
    var data = MyApp.dataController
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
                .background(Color.myPurpleDark)
                .tabItem {
                    Image(systemName: selection == .dictionary ? "book" : "text.book.closed")
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
                    Image(systemName:  "gearshape")
                    Text("Seting")
                }
                .tag(Tab.setting)

        }
        .background(Color.myPurpleDark)
        .navigationViewStyle(.stack)
        .sheet(isPresented: $lNManager.isPresented) {
            WordRememberView(word: data.mostPopularWord())
       
        }
        .onAppear(){
            
        
        }
    }
    
    func observerPressToKnowNotification(){
        NotificationCenter.default.addObserver(forName: Notifications.pressActionKnow,
                                               object: nil,
                                               queue: .main) { _ in
            guard let popularWord = data.mostPopularWord() else { return }
            data.resetPopularity(word: popularWord)
            
            guard let newPopularWord = data.mostPopularWord() else { return }
            lNManager.addNotification(for: newPopularWord)
        }
    }
    
    func observerPressCheckMeNotification(){
        NotificationCenter.default.addObserver(forName: Notifications.pressActionCheckMe,
                                               object: nil,
                                               queue: .main) { _ in
            
            guard let popularWord = data.mostPopularWord() else { return }
            lNManager.isPresented = true
            
        }
    }
    
    func observerPressNotKnowNotification(){
        NotificationCenter.default.addObserver(forName: Notifications.pressActionNotKnow,
                                               object: nil,
                                               queue: .main) { _ in
            print("pressActionNotKnow")
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
