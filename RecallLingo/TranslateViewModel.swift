//
//  DictViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 06.05.2023.
//


import MLKitTranslate
import SwiftUI

@MainActor
class TranslateViewModel: ObservableObject {
    @Published var networkMonitor = NetworkMonitor()
    @Published var wordRequest: String = ""
    @Published var wordResponse: String = ""
    @Published var isUniqueWord: Bool = false
    @AppStorage("isLanguageModelDownloaded") var isLanguageModelDownloaded: Bool = false
    @Published var textAlert = ""
    @Published var isShowAlert: ShowAlert?
    
    @Published var chat: [ChatUnit] = [
                ChatUnit(id: UUID(), wordUser: "The Lord of the Rings", wordTranslate: "Володар перснів")
                ]

    @Published var bufferID = UUID()
    @Published var tapppedID : UUID?
    @Published var isEditMode = false
    @Published var isContainInDict = false //make logica
    @Published var bufferMessageTranslate = ""
    @Published var isBlockingSendButton = false
    
    @Published var isTextFieldFocused = false
    
    @Published var isHidenTitle = false
    
    private let newMessage = NotificationCenter.default.publisher(for: Notifications.newMessage)
    
    let translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .ukrainian))
    
    let conditions = ModelDownloadConditions(allowsCellularAccess: false,
                                             allowsBackgroundDownloading: true)
    

    func isWordEntityStored(at key: String) -> Bool {
        return MyApp.dataController.isWordEntityStored(at: key)
    }
    
    func getWordEntity(key: String) -> WordEntity? {
        return MyApp.dataController.getWordEntity(key: key)
    }
    
    func sendMessageForTranslation(){
        translateText()
        let id = UUID()
        let newMessages = ChatUnit(id: id, wordUser: wordRequest, wordTranslate: "")
        chat.insert(newMessages, at: 0)
        bufferID = id
        NotificationCenter.default.post(name: Notifications.newMessage, object: newMessages)
        
    }
    
    ///Якщо слово відсутнє в БД, то перекладаємо через MLKitTranslate, інакше дістаємо переклад з БД
    func translateText() {
        let key = wordRequest.toKey()
        isBlockingSendButton = true
        
        if isWordEntityStored(at: key) {
            guard let word = getWordEntity(key: key) else {
                print("Error: getWordEntity = nil")
                return
            }
            
            recallTranslation(of: word)
            MyApp.dataController.increasePopularity(word: word)
        }
        else{
            handleMLKitTranslate()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isBlockingSendButton = false
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
     func handleMLKitTranslate(){
         if isLanguageModelDownloaded{
             self.translatingWithMLKitTranslate()
         } else if networkMonitor.isConnected{
             translator.downloadModelIfNeeded(with: conditions) { error in
                 if let error = error {
                     self.isShowAlert = ShowAlert(name: "Error translating text: \(error.localizedDescription)")
                 } else {
                     self.translatingWithMLKitTranslate()
                     self.isLanguageModelDownloaded = true
                 }
             }
         } else {
             self.isShowAlert = ShowAlert(name: "No internet connection. \n Please enable your internet connection to continue using our services.")
         }
    }
    
        ///Перекладаємо потрібне слово, відображаємо його в чаті, зберігаємо його в БД
    func translatingWithMLKitTranslate() {
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
        if let index = self.chat.firstIndex(where: {$0.id == self.bufferID}),
           self.chat[index].wordTranslate == "" {
            self.chat.remove(at: index)

            self.isShowAlert = ShowAlert(name: "Invalid Input\nPlease enter a valid word for translation.")
        }
    }
    
    func getTranslation(_ translation: String){
        self.wordResponse = translation
        self.addToDictionary()

    }
    
    //при натисканні на прапорець додавати або видаляти слово із словника
    func toggleWordDictionaryStatus(this message: ChatUnit) -> Bool{
        let key = message.wordUser.toKey()
        
        if isWordEntityStored(at: key) {
            MyApp.dataController.deleteWordAt(key: key)
            return false
        } else {
            addToDictionary(this: message)
            return true
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
    
    func addToDictionary(this message: ChatUnit){
        MyApp.dataController.new(key: message.wordUser.toKey(),
                                 original: message.wordUser,
                                 translate: message.wordTranslate)
    }

    func editing(this message: ChatUnit,
                 updateMessageStatus: @escaping () -> Void){
        if !isEditMode {
            clearTranslateData()
            isTextFieldFocused = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tapppedID = message.id
                self.isEditMode = true
                self.wordRequest = message.wordTranslate
                print("message.wordTranslate: \(message.wordTranslate)")
                print("wordRequest = \(self.wordRequest)")
                UITabBar.hideTabBar()
                updateMessageStatus()
            }
        }
    }
    
    func finishEditingTranslationThisWord(){
        
        if let tapID = tapppedID{
            if let index = chat.firstIndex(where: {$0.id == tapID}){
                
                chat[index].wordTranslate = bufferMessageTranslate
                
                if let word = getWordEntity(key: chat[index].wordUser.toKey()) {
                    word.translate = bufferMessageTranslate
                    MyApp.dataController.saveData()
                } else {
                    print("This wordEntity is not stored in the dictionary")
                }
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

    
    
    
    func sendTranslatedMessage(response: String){
        if !response.isEmpty{
            print("Переклад: \(response)")
            if let index = chat.firstIndex(where: {$0.id == bufferID}){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.chat[index].wordTranslate = response
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
    
    var isSendMessageButtonEnabled: Bool{
        if !isBlockingSendButton{
            if let _ = wordRequest.rangeOfCharacter(from: CharacterSets.englishSet){
                return isBlockingSendButton
            } else {
                return true
            }
        } else {
            return true
        }
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

    
    

