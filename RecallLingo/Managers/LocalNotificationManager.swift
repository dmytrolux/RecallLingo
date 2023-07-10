//
//  LocalNotificationController.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.05.2023.
//

import UserNotifications
import UIKit
import Combine

@MainActor
 final class LocalNotificationManager: NSObject, ObservableObject {
    
    private let center = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .badge, .sound]
     var data = MyApp.dataController
    
     var isGranted: Bool{
        didSet {
            UserDefaults.standard.set(isGranted, forKey: UDKey.isGranted)
        }
    }
    @Published var interval: TimeInterval{
        didSet {
            UserDefaults.standard.set(interval, forKey: UDKey.interval)
        }
    }
     
     @Published var isShowTranslate: Bool{
         didSet {
             UserDefaults.standard.set(isShowTranslate, forKey: UDKey.isShowTranslate)
         }
     }
    
    @Published var isEnable: Bool {
        didSet {
            if isEnable == true{
                if !isGranted{
                    requestAuthorization()
                    toogleOff()
                } else {
                    print("Notifications are enabled")
                }
                
            } else {
                print("Notifications are disabled")
                self.removeAllNotifications()
            }
            UserDefaults.standard.set(isEnable, forKey: UDKey.isEnable)

            func toogleOff(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isEnable = false
                }
            }
        }
    }
    
    @Published var isPresentedWordRememberView = false
    @Published var isPresentedWordDetailView = false
    
    override init () {
        
        isEnable = UserDefaults.standard.bool(forKey: UDKey.isEnable)
        isGranted = UserDefaults.standard.bool(forKey: UDKey.isGranted)
        
        UserDefaults.standard.register(defaults: [UDKey.interval: 60])
        interval = UserDefaults.standard.double(forKey: UDKey.interval)
        
        UserDefaults.standard.register(defaults: [UDKey.isShowTranslate: false])
        isShowTranslate = UserDefaults.standard.bool(forKey: UDKey.isShowTranslate)

        super.init()
        center.delegate = self
        
        observerPressToKnowNotification()
        observerPressCheckMeNotification()
        observerPressNotKnowNotification()
        
    }
     
     func requestAuthorization() {
         center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
             if success {
                 self.center.getNotificationSettings { settings in
                     self.isGranted = settings.authorizationStatus == .authorized
                     if self.isGranted {
                         DispatchQueue.main.async {
                             self.isEnable = true
                         }
                     }
                 }
             } else {
                 self.openSetting()
                 if let error = error {
                     print(error.localizedDescription)
                 }
             }
         }
     }

    
    
    
    func getCurrentSetting() async throws{
        let curentSetting = await center.notificationSettings()
        isGranted = (curentSetting.authorizationStatus == .authorized)
    }
    
    func openSetting(){
        if let url = URL(string: UIApplication.openSettingsURLString){
            if UIApplication.shared.canOpenURL(url){
                Task{
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    var category: UNNotificationCategory {
        let checkMe = UNNotificationAction(identifier: Action.checkMe,
                                           title: "nCheckMe".localized(),
                                           options: .foreground)
        
        let know = UNNotificationAction(identifier: Action.know,
                                        title: "nIKnow".localized(),
                                        options: .destructive)
        
        let doNotKnow = UNNotificationAction(identifier: Action.doNotKnow,
                                             title: "nINotKnow".localized(),
                                             options: .foreground)
        
        
        let category = UNNotificationCategory(identifier: "recallTheWord",
                                              actions: [checkMe, know, doNotKnow],
                                              intentIdentifiers: [],
                                              options: [])
        return category
    }
    
    func addNotification(for word: WordEntity, delaySec: TimeInterval?, scheduledDate: DateComponents?){
        self.removeAllNotifications()
        guard isEnable, word.popularity > 1 else {return}
        
        let content = UNMutableNotificationContent()
        content.title = "cRememberTranslation".localized()
        
        if let original = word.original{
            content.subtitle = "🇬🇧 " + original
        }
        
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "recallTheWord"
        content.userInfo = ["reminder": "WordRememberView"]
        
        if let translate = word.translate{
            if isShowTranslate{
                content.body = "🇺🇦 " + translate
            } else {
                let hiddenTransl = "🇺🇦 " + hidenTranslate(translate)
                content.body = hiddenTransl
            }
            
        }
        
        self.center.setNotificationCategories([category])
        content.categoryIdentifier = "recallTheWord"
        
        var trigger: UNNotificationTrigger{
            if let delaySec = delaySec{
                return UNTimeIntervalNotificationTrigger(timeInterval: delaySec, repeats: true)
            } else if let scheduledDate = scheduledDate {
                return UNCalendarNotificationTrigger(dateMatching: scheduledDate, repeats: false)
            } else {
                return UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            }
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        self.center.add(request)
    }
    
    
     func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
   
}



extension LocalNotificationManager: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
        switch response.actionIdentifier{
            
        case Action.know:
            NotificationCenter.default.post(name: Notifications.pressActionKnow, object: nil)
            
        case Action.doNotKnow:
            NotificationCenter.default.post(name: Notifications.pressActionNotKnow, object: nil)
            
        case Action.checkMe:
            self.isPresentedWordRememberView = true
            
        default:
            guard let _ = response.notification.request.content.userInfo["reminder"] as? String else { return }
            self.isPresentedWordRememberView = true
            
        }
        
    }
    
    func observerPressToKnowNotification(){
        NotificationCenter.default.addObserver(forName: Notifications.pressActionKnow,
                                               object: nil,
                                               queue: .main) { [weak self] _ in

            guard let popularWord = self?.data.mostPopularWord() else { return }
            self?.data.resetPopularity(word: popularWord)
            
            guard let newPopularWord = self?.data.mostPopularWord() else { return }
            self?.addNotification(for: newPopularWord, delaySec: self?.interval, scheduledDate: nil)
        }
    }
    
    func observerPressCheckMeNotification(){
        NotificationCenter.default.addObserver(forName: Notifications.pressActionCheckMe,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            self?.isPresentedWordRememberView = true
            
        }
    }
    
    func observerPressNotKnowNotification(){
        NotificationCenter.default.addObserver(forName: Notifications.pressActionNotKnow,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            self?.isPresentedWordDetailView = true

        }
    }
        
    func hidenTranslate(_ input: String) -> String {
       
        guard !input.isEmpty else { return input }
        var firstIndex: String.Index?
        var lastIndex: String.Index?
        
      
        // Проходимо через всі символи вхідного рядка
            for (index, char) in input.enumerated() {
                // Якщо символ належить до кирилиці
                if CharacterSets.cyrillicSet.contains(char.unicodeScalars.first!) {
                    // Якщо перший індекс ще не визначений, присвоюємо йому поточний індекс
                    if firstIndex == nil {
                        firstIndex = input.index(input.startIndex, offsetBy: index)
                    }
                    // Оновлюємо останній індекс поточним індексом
                    lastIndex = input.index(input.startIndex, offsetBy: index)
                }
            }
            
            // Перевіряємо, що знайшли хоча б один символ з латинського алфавіту
            guard let first = firstIndex, let last = lastIndex else { return input }
            
            // Створюємо змінну для збереження результату
            var output = ""
            
            // Знову проходимо через всі символи вхідного рядка
            for (index, char) in input.enumerated() {
                // Якщо символ належить до латинського алфавіту і не є першим або останнім таким символом
                if CharacterSets.cyrillicSet.contains(char.unicodeScalars.first!) && index != first.utf16Offset(in: input) && index != last.utf16Offset(in: input) {
                    // Додаємо зірочку до результату
                    output.append("*")
                } else {
                    // В іншому випадку додаємо сам символ до результату
                    output.append(char)
                }
            }
            
            // Повертаємо результат
            return output
        }
    
}


struct Action{
    static let know = "know"
    static let checkMe = "checkMe"
    static let doNotKnow = "doNotKnow"
}



