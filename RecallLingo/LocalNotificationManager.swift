//
//  LocalNotificationController.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.05.2023.
//

import UserNotifications
import UIKit

//в цьому класі прописати все, що стосується саме нотифікацій: від дозволу до їх планувальника
@MainActor
class LocalNotificationManager: NSObject, ObservableObject {
    
    private let center = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    
    @Published var isGranted: Bool{
        didSet {
            UserDefaults.standard.set(isGranted, forKey: UDKey.isGranted)
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
    
//    @Published var dataController: DataController
    @Published var isPresented = false
    
    override init () {
//        self.dataController = data
        
        isEnable = UserDefaults.standard.bool(forKey: UDKey.isEnable)
        isGranted = UserDefaults.standard.bool(forKey: UDKey.isGranted)
        
        super.init()
        center.delegate = self
    }

    
    func requestAuthorization(){
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
                self.center.getNotificationSettings { settings in
                    self.isGranted = settings.authorizationStatus == .authorized
                    if self.isGranted {
                        self.isEnable = true
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
    
    
    func addNotification(for word: WordEntity){
        self.removeAllNotifications()
        
        guard isEnable, word.popularity > 0 else {return}
        
        let content = UNMutableNotificationContent()
        content.title = "Remember the translation"
        content.subtitle = word.original ?? "Subtitle: error"
        content.body = "\(word.popularity)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = "recallTheWord"
        content.userInfo = ["reminder": "WordRememberView"]
        
        let know = UNNotificationAction(identifier: Action.know,
                                        title: "I know the translation",
                                        options: .destructive)
        
        let checkMe = UNNotificationAction(identifier: Action.checkMe,
                                           title: "Check me",
                                           options: .foreground)
        
        let doNotKnow = UNNotificationAction(identifier: Action.doNotKnow,
                                             title: "I do not know",
                                             options: .destructive)
        
        let category = UNNotificationCategory(identifier: "recallTheWord",
                                              actions: [know, checkMe, doNotKnow],
                                              intentIdentifiers: [],
                                              options: [])
        
        self.center.setNotificationCategories([category])
        content.categoryIdentifier = "recallTheWord"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        self.center.add(request)
    }
    
    
    
    
    private func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("removeAllNotifications()")
    }
    
    func printNotificationRequest(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
    
   
    
}



extension LocalNotificationManager: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner]
    }
    //при тапі на нотифікацію запускає
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let _ = response.notification.request.content.userInfo["reminder"] as? String{
            //            #warning("Додати перевірку наявність слів з популярністтю")
            self.isPresented = true
        }
        
        if response.actionIdentifier == Action.know{
            NotificationCenter.default.post(name: Notifications.pressActionKnow, object: nil)
        }
    }
        
    
}


struct Action{
    static let know = "know"
    static let checkMe = "checkMe"
    static let doNotKnow = "doNotKnow"
}
