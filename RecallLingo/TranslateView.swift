//
//  TranslateView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct TranslateView: View {
    @ObservedObject var viewModel: WordsModel
    var body: some View {
        VStack {
            
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
        .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
    }
}

struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView(viewModel: WordsModel())
    }
}
