//
//  MainView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = WordsModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
