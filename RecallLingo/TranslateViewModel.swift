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
class TranslateViewModel: ObservableObject {
    @Published var networkMonitor: NetworkMonitor
    @Published var wordRequest: String = ""
    @Published var wordResponse: String = ""
    @Published var isUniqueWord: Bool = false
    @AppStorage("isLanguageModelDownloaded") var isLanguageModelDownloaded: Bool = false
    @Published var textAlert = ""
    @Published var isShowAlert: ShowAlert?
    
    @Published var messages: [ChatReplica] = [
                ChatReplica(id: UUID(), userWord: "The Lord of the Rings", translate: "Володар перснів")
            ]

    @Published var bufferID = UUID()
    @Published var tapppedID : UUID?
    @Published var isEditMode = false
    @Published var isContainInDict = false //make logica
    @Published var bufferMessageTranslate = ""
    
    let translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .ukrainian))
    
    let conditions = ModelDownloadConditions(allowsCellularAccess: false,
                                             allowsBackgroundDownloading: true)
    

    func isUnique(at key: String) -> Bool {
        return MyApp.dataController.isUnique(at: key)
    }
    
    func getWordEntity(key: String) -> WordEntity? {
        return MyApp.dataController.getWordEntity(key: key)
    }
    
    ///Якщо слово відсутнє в БД, то перекладаємо через MLKitTranslate, інакше дістаємо переклад з БД
    func translateText() {
        let key = wordRequest.toKey()
        
        if isUnique(at: key) {
            prepareForTranslation()
        }
        else{
            guard let word = getWordEntity(key: key) else {
                print("Error: getWordEntity = nil")
                return
            }
            
            recallTranslation(of: word)
            MyApp.dataController.increasePopularity(word: word)
        }
    }
    
    ///
    func recallTranslation(of word: WordEntity){
        guard let translate = word.translate else {
            print("Error: WordEntity.translate = nil")
            return
        }
        wordResponse = translate
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
        translator.translate(wordRequest) { translatedText, error in
            if let error = error {
                self.isShowAlert = ShowAlert(name: "Error translating text: \(error.localizedDescription)")
                return
            }
            
            self.wordResponse = translatedText ?? "No translation available"
            self.addToDictionary()
//            self.isInputUnique()
            
        }
    }
    
    func addToDictionary(){
        guard !wordRequest.isEmpty else {
            print("add Error")
            return
        }
        print("id: \(wordRequest.toKey()), original: \(wordRequest), translate: \(wordResponse)")
        MyApp.dataController.new(key: wordRequest.toKey(),
                                 original: wordRequest,
                                 translate: wordResponse)
    }
    
    func editTranslationThisWord(to translate: String){
        guard let word = getWordEntity(key: wordRequest.toKey()) else {
            print("Error: getWordEntity = nil")
            return
        }
        word.translate = translate
        MyApp.dataController.saveData()
    }
    
    func editing(this message: ChatReplica){
        tapppedID = message.id
        isEditMode = true
        wordRequest = message.translate
    }
    
    func removeAt(word: WordEntity){
        MyApp.dataController.deleteWord(object: word)
    }
    
    func sendTranslatedMessage(response: String){
        if !response.isEmpty{
            print("Переклад: \(response)")
            if let index = messages.firstIndex(where: {$0.id == bufferID}){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.messages[index].translate = response
                    self.clearTranslateData()
                }
            } else {
                print("ereor index")
            }
        }
    }
    
    func clearTranslateData(){
        wordRequest = ""
        wordResponse = ""
        isEditMode = false
        tapppedID = nil
    }

    init(){
        self.networkMonitor = NetworkMonitor()
    }
}

extension String{
    func toKey() -> String{
        let key = self.lowercased()
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "’", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: " ", with: "")
        return key
    }
}


//    func removeAt(key: String){
//        guard let wordEntity = MyApp.dataController.savedEntities.first(where: {$0.id == key}) else {
//                print("No WordEntity found with id \(key)")
//                return
//            }
//        MyApp.dataController.deleteWord(object: wordEntity)
//    }
    
    
//    func removeAt(indexSet: IndexSet){
//        guard let index = indexSet.first else {return}
//        let wordEntity = MyApp.dataController.savedEntities[index]
//        MyApp.dataController.deleteWord(object: wordEntity)
//    }
