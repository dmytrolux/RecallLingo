//
//  DictViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 06.05.2023.
//


import MLKitTranslate
import SwiftUI

struct ShowAlert: Identifiable {
    var id: String { name }
    let name: String
}

@MainActor
class DictViewModel: ObservableObject {
    @Published var dataController: DataController
    @Published var networkMonitor: NetworkMonitor
    @Published var inputEn: String = ""
    @Published var outputUk: String = ""
    @Published var isUniqueWord: Bool = false
    @AppStorage("isLanguageModelDownloaded") var isLanguageModelDownloaded: Bool = false
    @Published var textAlert = ""
    @Published var isShowAlert: ShowAlert?
    
    var mostPopularWord: WordEntity?{
            let sortedEntities = dataController.savedEntities.sorted{$0.popularity > $1.popularity}
            let result = sortedEntities.first
            return result
    }

    
    var wordId: String{
        let formetedWord = inputEn.lowercased()
                        .trimmingCharacters(in: .whitespaces)
                        .replacingOccurrences(of: "'", with: "")
                        .replacingOccurrences(of: "’", with: "")
                        .replacingOccurrences(of: ",", with: "")
                        .replacingOccurrences(of: " ", with: "")
        return formetedWord
    }
    
    let translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .ukrainian))
    
    let conditions = ModelDownloadConditions(allowsCellularAccess: false,
                                             allowsBackgroundDownloading: true)
    

    func isUnique(at wordId: String) -> Bool {
        return !dataController.savedEntities.contains{$0.id == wordId}
    }
    
    func getWordEntity(id: String) -> WordEntity? {
        return dataController.savedEntities.first { $0.id == id }
    }
    
    ///Якщо слово відсутнє в БД, то перекладаємо через MLKitTranslate, інакше дістаємо переклад з БД
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
    
    ///
    func recallTranslation(of word: WordEntity){
        guard let translate = word.translate else {
            print("Error: WordEntity.translate = nil")
            return
        }
        outputUk = translate
    }
    
    ///Перекладаємо у випадку наявності мовної моделі, або завантажуємо її і перекладаємо, якщо не вдається завантажити її через відсутність інтернету то просимо користувача увімкнути інтернет
     func prepareForTranslation(){
         if isLanguageModelDownloaded{
             self.startTranslating()
         } else if networkMonitor.isConnected{
             translator.downloadModelIfNeeded(with: conditions) { error in
                 if let error = error {
                     self.isShowAlert = ShowAlert(name: "Error translating text: \(error.localizedDescription)")
                 } else {
                     self.startTranslating()
                     self.isLanguageModelDownloaded = true
                 }
             }
         } else {
             self.isShowAlert = ShowAlert(name: "No internet connection. \n Please enable your internet connection to continue using our services.")
         }
    }
    
        ///Перекладаємо потрібне слово, відображаємо його в чаті, зберігаємо його в БД
    func startTranslating() {
        translator.translate(inputEn) { translatedText, error in
            if let error = error {
                self.isShowAlert = ShowAlert(name: "Error translating text: \(error.localizedDescription)")
                return
            }
            
            self.outputUk = translatedText ?? "No translation available"
            self.addToDictionary()
//            self.isInputUnique()
            
        }
    }
    
    func addToDictionary(){
        guard !inputEn.isEmpty else {
            print("add Error")
            return
        }
        print("id: \(wordId), original: \(inputEn), translate: \(outputUk)")
        dataController.new(id: wordId, original: inputEn, translate: outputUk)
//        clearTextFields()
//        isUniqueWord = false
    }
    
//    func isInputUnique(){
//        isUniqueWord = !dataController.savedEntities.contains{$0.id == wordId}
//    }
    
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

    init(dataController: DataController){
        self.dataController = dataController
        self.networkMonitor = NetworkMonitor()
//        self.translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .ukrainian))
        
    }
}
