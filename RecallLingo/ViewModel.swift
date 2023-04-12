//
//  ViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import MLKitTranslate
import SwiftUI

class WordsModel: ObservableObject {
    @Published var dict: [String: Word] = UserDefaults.standard.dictionary(forKey: "Dict") as? [String: Word] ?? [:] {
        didSet{
            if let encoded = try? JSONEncoder().encode(dict){
                UserDefaults.standard.set(encoded, forKey: "Dict")
            }
        }
    }
    
    @Published var inputEn: String = ""
    @Published var outputUk: String = ""
    
    #warning("provide word.translate if dict[input_en] != nil")
    @Published var isUniqueWord: Bool = false
    
    private let translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english,
                                                                              targetLanguage: .ukrainian))
    
    private let conditions = ModelDownloadConditions(allowsCellularAccess: false,
                                                          allowsBackgroundDownloading: true)
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Dict"),
           let decodedItems = try? JSONDecoder().decode([String: Word].self, from: savedItems) {
            dict = decodedItems
        } else {
            dict = [String: Word]()
        }
    }
    
    func translateText() {
        downloadedModelIfNeeded()
    }
    
    private func downloadedModelIfNeeded(){
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            self.startTranslating()
        }
    }
    
    private func startTranslating() {
        translator.translate(inputEn) { translatedText, error in
            if let error = error {
                print("Error translating text: \(error)")
                self.outputUk = "Error translating text"
                return
            }
            self.outputUk = translatedText ?? "No translation available"
            self.isInputUnique()
            self.updateDict()
            print(self.dict)
        }
    }
    
    func addToDictionary(){
        //available when dict[input_en] == nil
        if !inputEn.isEmpty && dict[inputEn] == nil{
            dict[inputEn.formatToDictKey()] = Word(original: inputEn, translate: outputUk)
            clearTextFields()
            isUniqueWord = false
        }
    }
    
    func isInputUnique(){
        isUniqueWord = (dict[inputEn.formatToDictKey()] == nil) ? true : false
    }
    
    private func updateDict(){
        if var word = dict[inputEn.formatToDictKey()] {
            word.popularity += 1
            dict[inputEn.formatToDictKey()] = word
        }
    }
    
    func clearDict(){
        self.dict.removeAll()
    }
    
    func clearTextFields(){
        inputEn = ""
        outputUk = ""
    }
    
}

extension String{
    func formatToDictKey() -> String{
        let formeted = self.lowercased()
                        .trimmingCharacters(in: .whitespaces)
                        .replacingOccurrences(of: "'", with: "")
                        .replacingOccurrences(of: "’", with: "")
                        .replacingOccurrences(of: " ", with: "_")
        return formeted
    }
}
