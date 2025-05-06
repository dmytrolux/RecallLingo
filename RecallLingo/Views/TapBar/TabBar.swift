//
//  Item.swift
//  RecallLingo
//
//  Created by Дмитро on 06.05.2025.
//

import SwiftUI

class TabBarController: ObservableObject {
    @Published var isVisible: Bool = true
    @Published var selectedTab = 1
}

struct CustomTabView: View {
    @Binding var selectedTab: Int

    let items: [(icon: String, label: String)] = [
        ("globe", "tbTranslate"),
        ("text.book.closed", "tbDictionary"),
        ("chart.line.uptrend.xyaxis", "tbStatistic"),
        ("gearshape", "tbSetting")
    ]

    var body: some View {
        VStack(spacing: 0){
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == index ? items[index].icon : items[index].icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(selectedTab == index ? .accentColor : .gray)

                        Text(LocalizedStringKey(items[index].label))
                            .font(.footnote)
                            .foregroundColor(selectedTab == index ? .accentColor : .gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 3)
                    .onTapGesture {
                        selectedTab = index
                    }
                }
            }
            .padding(.horizontal, 5)
           
            .frame(height: 60)
            
            Spacer().frame(height: 20)
        }
        .background(Color.myPurpleDark.ignoresSafeArea(edges: .bottom))
    }
}


struct TabContentView: View {
    @EnvironmentObject var tabBarController: TabBarController
    var data = MyApp.dataController

    var body: some View {
        ZStack {
            TranslateView()
                .opacity(tabBarController.selectedTab == 0 ? 1 : 0)
               

            DictionaryView()
                .opacity(tabBarController.selectedTab == 1 ? 1 : 0)

            StatisticView()
                .opacity(tabBarController.selectedTab == 2 ? 1 : 0)

            SettingsView()
                .opacity(tabBarController.selectedTab == 3 ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



struct CustomTabBar: View {
    @EnvironmentObject var tabBarController: TabBarController
    
    var body: some View {
        ZStack{
            ZStack{
                
                
                VStack{
                    TabContentView()
                    
                    Spacer(minLength: 0)
                    
                    if tabBarController.isVisible {
                        CustomTabView(selectedTab: $tabBarController.selectedTab)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .ignoresSafeArea()
    }
    
}
