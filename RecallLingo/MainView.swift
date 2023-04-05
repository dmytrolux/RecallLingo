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
            Button("Clear Dict") {
                viewModel.clearDict()
            }
            Spacer()
            TextField("Enter text", text: $viewModel.inputEn)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Button {
                viewModel.translateText()
            } label: {
                Text("Translate")
            }
            Spacer()
            
            TextField("", text: $viewModel.outputUk)
                .textFieldStyle(.roundedBorder)
                .accessibilityHint("Translated text")
                
            if viewModel.isUniqueWord{
                Button("Add to dictionary") { viewModel.addToDictionary() }
            }
            
            Spacer()
        }
    }
    
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
