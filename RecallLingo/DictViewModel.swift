//
//  DictViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 06.05.2023.
//


import MLKitTranslate
import SwiftUI

@MainActor
class DictViewModel: ObservableObject {
    @Published var dataController: DataController
    @Published var inputEn: String = ""
    @Published var outputUk: String = ""
    @Published var isUniqueWord: Bool = false
    
    var mostPopularWord: WordEntity?{
        let sortedEntities = dataController.savedEntities.sorted{$0.popularity > $1.popularity}
        return sortedEntities.first
    }
    
    var wordId: String{
        let formetedWord = inputEn.lowercased()
                        .trimmingCharacters(in: .whitespaces)
                        .replacingOccurrences(of: "'", with: "")
                        .replacingOccurrences(of: "’", with: "")
                        .replacingOccurrences(of: " ", with: "_")
        return formetedWord
    }
    
     let translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english,
                                                                       targetLanguage: .ukrainian))
    
     let conditions = ModelDownloadConditions(allowsCellularAccess: false,
                                              allowsBackgroundDownloading: true)
    
    func isUnique(at wordId: String) -> Bool {
        return !dataController.savedEntities.contains{$0.id == wordId}
    }
    
    func getWordEntity(id: String) -> WordEntity? {
        return dataController.savedEntities.first { $0.id == id }
    }
    
    func translateText() {
        if isUnique(at: wordId) {
            prepareForTranslation()
        }
        else{
            guard let word = getWordEntity(id: wordId) else {
                print("Error: getWordEntity = nil")
                return
            }
            recallTranslation(of: word)
            increasePopularity(word: word)
        }
    }
    
    func recallTranslation(of word: WordEntity){ //або WordEntity
        guard let translate = word.translate else {
            print("Error: WordEntity.translate = nil")
            return
        }
        outputUk = translate
    }
    
     func prepareForTranslation(){
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            self.startTranslating()
        }
    }
    
    func startTranslating() {
        translator.translate(inputEn) { translatedText, error in
            if let error = error {
                print("Error translating text: \(error)")
                self.outputUk = "Error translating text"
                return
            }
            self.outputUk = translatedText ?? "No translation available"
            self.isInputUnique()
        }
    }
    
    func addToDictionary(){
        guard !inputEn.isEmpty, isUnique(at: wordId) else {
            print("add Error")
            return
        }
        dataController.new(word: WordModel(id: wordId,
                                           original: inputEn,
                                           translate: outputUk,
                                           popularity: 1,
                                          date: Date()))
        clearTextFields()
        isUniqueWord = false
          
    }
    
    func isInputUnique(){
        isUniqueWord = !dataController.savedEntities.contains{$0.id == wordId}
    }
    
    func increasePopularity(word: WordEntity) {
        guard dataController.savedEntities.contains(word) else {
                print("Word not found in savedEntities")
                return
            }
        word.popularity += 1
        dataController.saveData()
    }
    
    func decreasePopularity(word: WordEntity){
        guard dataController.savedEntities.contains(word) else {
                print("Word not found in savedEntities")
                return
            }
        word.popularity -= 1
        dataController.saveData()
        
    }
    
    func removeAt(idWord: String){
        guard let wordEntity = dataController.savedEntities.first(where: {$0.id == idWord}) else {
                print("No WordEntity found with id \(idWord)")
                return
            }
        dataController.deleteWord(object: wordEntity)
    }
    
    func removeAt(word: WordEntity){
        dataController.deleteWord(object: word)
    }
    
    func removeAt(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let wordEntity = dataController.savedEntities[index]
        dataController.deleteWord(object: wordEntity)
    }
    
    
    
    func clearTextFields(){
        inputEn = ""
        outputUk = ""
    }
    
//    func getMostPopularWord() -> WordModel? {
//        let word = self.mostPopularWord
//        return WordModel(id: word?.id ?? "error id",
//                         original: word?.original ?? "error original",
//                         translate: word?.translate ?? "error translate",
//                         popularity: word?.popularity ?? 1)
//    }
    
    
    
    
    init(dataController: DataController){
        self.dataController = dataController
    }
}
