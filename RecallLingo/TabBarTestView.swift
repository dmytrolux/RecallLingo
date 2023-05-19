//
//  TabBarTestView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 15.05.2023.
//

import SwiftUI

struct TabBarTestView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            
            TranslateTestView()
                .background(Color.myPurpleDark)
                .tabItem {
                    Image(systemName: "globe")
                    Text("Translate")
                }
                .tag(0)
            
            TranslateTestView()
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("Dictionary")
                }
                .tag(1)
            //
            TranslateTestView()
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Statistic")
                }
                .tag(2)
            //
            TranslateTestView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Seting")
                }
                .tag(3)
        }
    }
}

struct TabBarTestView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarTestView()
    }
}
