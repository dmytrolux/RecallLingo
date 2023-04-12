//
//  MainScreen.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI


struct MainScreen: View {
    @ObservedObject var viewModel: WordsModel
    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            TranslateView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "globe")
                    Text("Translate")
                }
                .tag(0)
            
            DictionaryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("Dictionary")
                }
                .tag(1)
            
            StatisticView(viewModel: viewModel)
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Statistic")
                }
            
           SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Seting")
                }
                .tag(2)
            
            
            
        }
        .onAppear(){
            
        }
   
    }
    
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(viewModel: WordsModel())
//            .environmentObject(Order())
    }
}
