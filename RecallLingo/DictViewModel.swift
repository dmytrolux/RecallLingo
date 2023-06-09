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
//    @Published var dataController: DataController
    @Published var networkMonitor: NetworkMonitor
    @Published var wordRequest: String = ""
    @Published var wordResponse: String = ""
    @Published var isUniqueWord: Bool = false
    @AppStorage("isLanguageModelDownloaded") var isLanguageModelDownloaded: Bool = false
    @Published var textAlert = ""
    @Published var isShowAlert: ShowAlert?
    
    @Published var messages: [ChatReplica] = [
        //        ChatReplica(id: UUID(), userWord: "We must all face the choice between what is right and what is easy", translate: "Ми всі повинні обирати між тим, що правильно і тим, що просто "),
        //        ChatReplica(id: UUID(), userWord: "The will to win the desire to succeed, the urge to reach your full potential… these are the keys that will unlock the door to personal excellence. Confucius", translate: "Воля до перемоги, бажання домогтися успіху, прагнення повністю розкрити свої можливості… ось ті ключі, які відкриють двері до особистої досконалості. Конфуцій"),
        //        ChatReplica(id: UUID(), userWord: "Car", translate: "Автомобіль"),
        //        ChatReplica(id: UUID(), userWord: "The truth was that she was a woman before she was a scientist.", translate: "Небо"),
                ChatReplica(id: UUID(), userWord: "The Lord of the Rings", translate: "Володар перснів")
            ]
    
    
    @Published var bufferID = UUID()
    @Published var tapppedID : UUID?
    @Published var isEditMode = false
    @Published var isContainInDict = false //make logica
    @Published var bufferMessageTranslate = ""
    
    var mostPopularWord: WordEntity?{
        let sortedEntities = RecallLingoApp.dataController.savedEntities.sorted{$0.popularity > $1.popularity}
            let result = sortedEntities.first
            return result
    }

    
    var wordId: String{
        let formetedWord = wordRequest.lowercased()
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
        return !RecallLingoApp.dataController.savedEntities.contains{$0.id == wordId}
    }
    
    func getWordEntity(id: String) -> WordEntity? {
        return RecallLingoApp.dataController.savedEntities.first { $0.id == id }
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
        print("id: \(wordId), original: \(wordRequest), translate: \(wordResponse)")
        RecallLingoApp.dataController.new(id: wordId, original: wordRequest, translate: wordResponse)
//        clearTextFields()
//        isUniqueWord = false
    }
    
    func editTranslationThisWord(to translate: String){
        guard let word = getWordEntity(id: wordId) else {
            print("Error: getWordEntity = nil")
            return
        }
        word.translate = translate
        RecallLingoApp.dataController.saveData()
    }

    
    func increasePopularity(word: WordEntity) {
        guard RecallLingoApp.dataController.savedEntities.contains(word) else {
                print("Word not found in savedEntities")
                return
            }
        word.popularity += 1
        RecallLingoApp.dataController.saveData()
    }
    
    func decreasePopularity(word: WordEntity){
        guard RecallLingoApp.dataController.savedEntities.contains(word) else {
                print("Word not found in savedEntities")
                return
            }
        word.popularity -= 1
        RecallLingoApp.dataController.saveData()
        
    }
    
    func removeAt(idWord: String){
        guard let wordEntity = RecallLingoApp.dataController.savedEntities.first(where: {$0.id == idWord}) else {
                print("No WordEntity found with id \(idWord)")
                return
            }
        RecallLingoApp.dataController.deleteWord(object: wordEntity)
    }
    
    func removeAt(word: WordEntity){
        RecallLingoApp.dataController.deleteWord(object: word)
    }
    
    func removeAt(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let wordEntity = RecallLingoApp.dataController.savedEntities[index]
        RecallLingoApp.dataController.deleteWord(object: wordEntity)
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
//        self.dataController = dataController
        self.networkMonitor = NetworkMonitor()
        
    }
}
