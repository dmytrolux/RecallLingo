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
    @EnvironmentObject var tabBarController: TabBarController
    
    var body: some View {
        CustomTabBar()
            .background(Color.myPurpleDark)
            .navigationViewStyle(.stack)
            .sheet(isPresented: $lNManager.isPresentedWordRememberView) {
                WordRememberView(word: data.mostPopularWord())
                
            }
            .sheet(isPresented: $lNManager.isPresentedWordDetailView) {
                
                if let mostPopularWord = data.mostPopularWord() {
                    WordDetailView(word: mostPopularWord)
                }
            }
    }
}

enum Tab {
    case translate, dictionary, statistic, setting
}

extension String{
    func localized() -> String{
        return NSLocalizedString(self, comment: "")
    }
}
