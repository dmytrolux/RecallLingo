//
//  MainView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI
import MLKitTranslate

struct MainView: View {
    //    @ObservedObject var viewModel = WordsModel()
    @State var text: String = ""
    @State var result: String = ""
    
    private let translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english,
                                                                              targetLanguage: .ukrainian))
    
    private let conditions = ModelDownloadConditions(allowsCellularAccess: false,
                                                          allowsBackgroundDownloading: true)
    
    var body: some View {
        
        VStack {
            Spacer()
            TextField("In word", text: $text)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Button {
                translateText()
            } label: {
                Text("Translate")
            }
            Spacer()
            Text("Result: \(result)")
            Spacer()
        }
    }
    
    private func translateText() {
        downloadedModelIfNeeded()
        startTranslating()
    }
    
    private func downloadedModelIfNeeded(){
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            startTranslating()
        }
    }
    
    private func startTranslating() {
        translator.translate(text) { translatedText, error in
            if let error = error {
                print("Error translating text: \(error)")
                result = "Error translating text"
                return
            }
            result = translatedText ?? "No translation available"
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
