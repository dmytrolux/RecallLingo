//
//  MainScreen.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

struct MainScreen: View {
    @StateObject var vm = DictionaryViewModel(notificationsManager: LocalNotificationManager())
    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            TranslateView(vm: vm)
                .tabItem {
                    Image(systemName: "globe")
                    Text("Translate")
                }
                .tag(0)
            
            DictionaryView(vm: vm)
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("Dictionary")
                }
                .tag(1)
            
            StatisticView(vm: vm)
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Statistic")
                }
                .tag(2)
            
            SettingsView(vm: vm)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Seting")
                }
                .tag(3)
            
            
            
        }
        .onAppear(){
//            viewModel.registerNotificationCategory()
//            viewModel.scheduleHourlyNotification()
            vm.addNotificationSequence()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
