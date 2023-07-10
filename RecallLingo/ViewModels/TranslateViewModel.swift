//
//  DictViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 06.05.2023.
//


import MLKitTranslate
import SwiftUI

@MainActor
final class TranslateViewModel: ObservableObject {
    @Published var networkMonitor = NetworkMonitor()
    @Published var wordRequest: String = ""
    @Published var wordResponse: String = ""
    @Published var isUniqueWord: Bool = false
    @AppStorage("isLanguageModelDownloaded") var isLanguageModelDownloaded: Bool = false
    @Published var textAlert = ""
    @Published var isShowAlert: ShowAlert?
    
    @Published var chat: [ChatUnit] = [
        ChatUnit(id: UUID(), wordUser: "Write me, please!", wordTranslate: "Напишіть мені, будь ласка!"),
    ]

    @Published var bufferID = UUID()
    @Published var tapppedID : UUID?
    @Published var isEditMode = false
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
        wordRequest = wordRequest.trimmingCharacters(in: CharacterSets.latinSet.inverted)
        translateText()
        let id = UUID()
        let newMessages = ChatUnit(id: id, wordUser: wordRequest, wordTranslate: "")
        chat.insert(newMessages, at: 0)
        bufferID = id
        NotificationCenter.default.post(name: Notifications.newMessage, object: newMessages)
        
    }

    func translateText() {
        let key = wordRequest.toKey()
        isBlockingSendButton = true
        
        if isWordEntityStored(at: key) {
            guard let word = getWordEntity(key: key) else {
                print("Error: getWordEntity = nil")
                return
            }
            
            getFromStorage(at: word)
            MyApp.dataController.increasePopularity(word: word)
        }
        else{
            handleMLKitTranslate()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isBlockingSendButton = false
        }

    }
    
    func getFromStorage(at word: WordEntity){
        guard let translate = word.translate else {
            print("Error: WordEntity.translate = nil")
            return
        }
        wordResponse = translate
        
    }
    
    ///Translate if there is a language model, or download it and translate. If it is not possible to download it due to the lack of Internet, then we ask the user to turn on the Internet
     func handleMLKitTranslate(){
         if isLanguageModelDownloaded{
             self.translatingWithMLKitTranslate()
         } else if networkMonitor.isConnected{
             translator.downloadModelIfNeeded(with: conditions) { error in
                 if let error = error {
                     self.isShowAlert = ShowAlert(name: "aErrorTransl" + error.localizedDescription )
                 } else {
                     self.translatingWithMLKitTranslate()
                     self.isLanguageModelDownloaded = true
                 }
             }
         } else {
             self.isShowAlert = ShowAlert(name: "aNoInternet")
         }
    }
    
        ///Перекладаємо потрібне слово, відображаємо його в чаті, зберігаємо його в БД
    func translatingWithMLKitTranslate() {
        translator.translate(wordRequest) {translation, error in
            
            if let error {
                self.isShowAlert = ShowAlert(name: "aErrorTransl" + error.localizedDescription )
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

            self.isShowAlert = ShowAlert(name: "aInvalidInput")
        }
    }
    
    func getTranslation(_ translation: String){
        self.wordResponse = translation.trimmingCharacters(in: CharacterSets.latinAndCyrillicSet.inverted)
        self.addToDictionary()

    }
    
    ///checkmark adds or removes a word from the dictionary
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
    
    var isSendMessageButtonDisabled: Bool{
        if !isBlockingSendButton{
            if let _ = wordRequest.rangeOfCharacter(from: CharacterSets.latinSet){
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    var isEditDoneViewDisabled: Bool{
        if let _ = wordRequest.rangeOfCharacter(from: CharacterSets.cyrillicSet){
            return false
        } else {
            return true
        }
    }
    
    func handleReceivedText(_ text: String) {
            if !isEditMode {
                let filteredText = text
                    .components(separatedBy: CharacterSets.latinAndSymbolSet.inverted)
                    .joined()
                if filteredText != text {
                    wordRequest = filteredText
                }
            } else {
                let filteredText = text.components(separatedBy: CharacterSets.allowedCharacterSet.inverted).joined()
                if filteredText != text {
                    wordRequest = filteredText
                }
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

    
    

