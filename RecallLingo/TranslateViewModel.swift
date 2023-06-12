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
    @Published var sendMessageForTranslationButtonIsDisabled = false
    
    @Published var isTextFieldFocused = false
    
    let translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .ukrainian))
    
    let conditions = ModelDownloadConditions(allowsCellularAccess: false,
                                             allowsBackgroundDownloading: true)
    

    func isUnique(at key: String) -> Bool {
        return MyApp.dataController.isUnique(at: key)
    }
    
    func getWordEntity(key: String) -> WordEntity? {
        return MyApp.dataController.getWordEntity(key: key)
    }
    
    func sendMessageForTranslation(){
        translateText()
        let id = UUID()
        let newMessages = ChatReplica(id: id, userWord: wordRequest, translate: "")
        messages.insert(newMessages, at: 0)
        bufferID = id
    }
    
    ///Якщо слово відсутнє в БД, то перекладаємо через MLKitTranslate, інакше дістаємо переклад з БД
    func translateText() {
        let key = wordRequest.toKey()
        sendMessageForTranslationButtonIsDisabled = true
        
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
            sendMessageForTranslationButtonIsDisabled = false
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
        translator.translate(wordRequest) {translation, error in
            
            if let error {
                self.isShowAlert = ShowAlert(name: "Error translating text: \(error.localizedDescription)")
                return
            }
            
            if let translation {
                if translation.toKey() == self.wordRequest.toKey(){
                    self.removeInvalidRequest()
                } else {
                    self.getTranslation(translation)
                }
            }
        }
    }
    
    func removeInvalidRequest(){
        if let index = self.messages.firstIndex(where: {$0.id == self.bufferID}),
           self.messages[index].translate == "" {
            self.messages.remove(at: index)
            self.sendMessageForTranslationButtonIsDisabled = false
            self.isShowAlert = ShowAlert(name: "Invalid Input/nPlease enter a valid word for translation.")
        }
    }
    
    func getTranslation(_ translation: String){
        self.wordResponse = translation
        self.addToDictionary()
        self.sendMessageForTranslationButtonIsDisabled = false
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

    func editing(this message: ChatReplica,
                 updateMessageStatus: @escaping () -> Void){
        if !isEditMode {
            clearTranslateData()
            isTextFieldFocused = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tapppedID = message.id
                self.isEditMode = true
                self.wordRequest = message.translate
                print(message.translate)
                UITabBar.hideTabBar()
                updateMessageStatus()
            }
        }
    }
    
    func editTranslationThisWord(){
        
        if let tapID = tapppedID{
            if let index = messages.firstIndex(where: {$0.id == tapID}){
                
                messages[index].translate = bufferMessageTranslate.capitalized
                
                guard let word = getWordEntity(key: messages[index].userWord.toKey()) else {
                    print("Error: getWordEntity = nil"); return }
                word.translate = bufferMessageTranslate
                MyApp.dataController.saveData()
            } else {
                print("id message error")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tapppedID = nil
                self.isEditMode = false
            }
        } else {
            print("tapped error")
        }
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
            .replacingOccurrences(of: ".", with: "")
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
