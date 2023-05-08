//
//  ViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import MLKitTranslate
import SwiftUI

//struct WordModel{
//    var id: String = "",
//    var original: String = "",
//    var translate: String = "",
//    var popularity: Int = 1
//}

@MainActor class DictionaryViewModel: ObservableObject {
    
    @Published var dataController: DataController
    
    @Published var dict: [String: Word] = UserDefaults.standard.dictionary(forKey: "Dict") as? [String: Word] ?? [:] {
        didSet{
            if let encoded = try? JSONEncoder().encode(dict){
                UserDefaults.standard.set(encoded, forKey: "Dict")
            }
        }
    }
    
    @Published var inputEn: String = ""
    @Published var outputUk: String = ""
    @Published var isUniqueWord: Bool = false
    
//    @Published var notificationsManager: LocalNotificationManager
    
    var mostPopularWord: Word?{
        if !dict.isEmpty{
            let word = dict.values.max { $0.popularity < $1.popularity } ?? Word()
            if word.popularity > 1{
                return word
            } else {
                return nil
            }
        }
        return nil
    }
    
    private let translator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english,
                                                                              targetLanguage: .ukrainian))
    
    private let conditions = ModelDownloadConditions(allowsCellularAccess: false,
                                                          allowsBackgroundDownloading: true)
    
//    init(notificationsManager: LocalNotificationManager){
//        self.notificationsManager = notificationsManager
//        if let savedItems = UserDefaults.standard.data(forKey: "Dict"),
//           let decodedItems = try? JSONDecoder().decode([String: Word].self, from: savedItems) {
//            dict = decodedItems
//        } else {
//            dict = [String: Word]()
//        }
//    }
    
    init(dataController: DataController){
        self.dataController = dataController
        if let savedItems = UserDefaults.standard.data(forKey: "Dict"),
           let decodedItems = try? JSONDecoder().decode([String: Word].self, from: savedItems) {
            dict = decodedItems
        } else {
            dict = [String: Word]()
        }
    }
    
    func translateText() {
        if var word = dict[inputEn.formatToDictKey()] {
            recallTranslation(of: word)
            increasePopularity(in: &word)
        } else {
            prepareForTranslation()
        }
    }
    
    private func recallTranslation(of word: Word){
        outputUk = word.translate
    }
    
    private func prepareForTranslation(){
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
//            self.updateDict()
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
    
     func increasePopularity(in word: inout Word){
            word.popularity += 1
         dict[word.original.formatToDictKey()] = word
    }
    
    func decreasePopularity(in word: inout Word){
        if word.popularity > 0 {
            word.popularity -= 1
            dict[word.original.formatToDictKey()] = word
        }
    }
    
    func remove(this word: Word){
        dict.removeValue(forKey: word.original.formatToDictKey())
    }
    
    func clearDict(){
        self.dict.removeAll()
    }
    
    func clearTextFields(){
        inputEn = ""
        outputUk = ""
    }
    
    func getMostPopularWord() -> Word? {
        return dict.values.max(by: { $0.popularity < $1.popularity })
    }
    
//    func registerNotificationCategory() {
//          let openAppAction = UNNotificationAction(identifier: "openAppAction", title: "Відкрити додаток", options: [.foreground])
//          let openWordAction = UNNotificationAction(identifier: "openWordAction", title: "Перейти до слова", options: [.foreground])
//          let closeAction = UNNotificationAction(identifier: "closeAction", title: "Закрити", options: [.destructive])
//
//          let notificationCategory = UNNotificationCategory(identifier: "wordNotificationCategory", actions: [openAppAction, openWordAction, closeAction], intentIdentifiers: [], options: [])
//
//          UNUserNotificationCenter.current().setNotificationCategories([notificationCategory])
//      }
      
//      func scheduleHourlyNotification() {
//          let center = UNUserNotificationCenter.current()
//          center.removeAllPendingNotificationRequests()
//
//          for hour in 1...2 { // через це не працює
//              let content = UNMutableNotificationContent()
//              content.title = "Найпопулярніше слово"
//              content.sound = UNNotificationSound.default
//
////              let dict = self.dict
////              let mostPopularWord = findMostPopularWord(dict: dict)
//
////              content.body = "Cлово '\(mostPopularWord.original)' має популярність \(mostPopularWord.popularity)"
//              content.body = "sss"
////              content.categoryIdentifier = "wordNotificationCategory"
//
//              let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(hour*600), repeats: true)
//              let request = UNNotificationRequest(identifier: "hourlyNotification", content: content, trigger: trigger)
//          center.add(request) { (error) in
//              if error != nil {
//                  print("Error scheduling notification: \(error!.localizedDescription)")
//              }
//          }
//          }
//      }
      
//      private func findMostPopularWord(dict: [String: Word]) -> Word {
//          var mostPopularWord = Word(original: "", translate: "", popularity: 0)
//          for (_, word) in dict {
//              if word.popularity > mostPopularWord.popularity {
//                  mostPopularWord = word
//              }
//          }
//          return mostPopularWord
//      }
    
//    func sendNotification() {
//        let center = UNUserNotificationCenter.current()
//
//        let bestWord = dict.values.max { $0.popularity < $1.popularity }
//        let content = UNMutableNotificationContent()
//        content.title = "RecallLingo"
//        content.body = "\(bestWord?.original ?? "No word available") - \(bestWord?.translate ?? "No translation available")"
//        content.sound = .default
//
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//        let request = UNNotificationRequest(identifier: "Word of the Hour", content: content, trigger: trigger)
//        center.add(request) { (error) in
//            if error != nil {
//                print("Error scheduling notification: \(error!.localizedDescription)")
//            }
//        }
//    }
    
//    func addNotificationSequence(){
//        guard let mostPopularWord else {return}
//
//        let center = UNUserNotificationCenter.current()
//
//        let addRequests = {
//            for time in 8..<22 {
//                self.addRequest(popWord: mostPopularWord,
//                                time: time,
//                                center: center)
//            }
//        }
//
//        center.getNotificationSettings { setting in
//            if setting.authorizationStatus == .authorized{
//                addRequests()
//            } else {
//                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                    if success{
//                        addRequests()
//                    } else {
//                        print("There will be no notification")
//                    }
//                }
//            }
//        }
//
//
//    }
    

//    func addRequest(popWord: Word, time: Int, center:  UNUserNotificationCenter) -> Void{
//            let content = UNMutableNotificationContent()
//            content.title = popWord.original
//            content.subtitle = popWord.translate
//            content.sound = .default
//            var dateComponents = DateComponents()
//            dateComponents.hour = time
//
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//            let request = UNNotificationRequest(identifier: UUID().uuidString,
//                                                content: content,
//                                                trigger: trigger)
//            center.add(request)
//    }
   
//    func toggleNotificationPermission(isEnabled: Bool) {
//        let center = UNUserNotificationCenter.current()
//        center.getNotificationSettings { settings in
//            switch settings.authorizationStatus {
//            case .notDetermined:
//                // Запитати користувача про дозвіл на сповіщення
//                center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//                    if let error = error {
//                        print("Error: \(error.localizedDescription)")
//                    }
//                }
//            case .authorized:
//                // Встановити дозвіл на сповіщення
//                center.removeAllPendingNotificationRequests()
//                center.removeAllDeliveredNotifications()
//            case .denied:
//                // Вимкнути дозвіл на сповіщення
//                center.removeAllPendingNotificationRequests()
//                center.removeAllDeliveredNotifications()
//            default:
//                break
//            }
//        }
//    }

    func printNotification(){
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            print("Pending notification requests:")
            for request in requests {
                print(request)
            }
        })
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



