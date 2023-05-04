//
//  LocalNotificationManager.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.05.2023.
//

import Foundation
import UserNotifications

//в цьому класі прописати все, що стосується саме нотифікацій: від дозволу до їх планувальника
@MainActor
class LocalNotificationManager: ObservableObject {
    
    let center = UNUserNotificationCenter.current()
    
    let isNotificationEnableKey = "isNotificationEnable"
    
    var isNotificationEnable: Bool {
        didSet {
            UserDefaults.standard.set(isNotificationEnable, forKey: isNotificationEnableKey)
        }
    }
 
    
    init (){
        UserDefaults.standard.register(defaults: [isNotificationEnableKey: true])
        isNotificationEnable = UserDefaults.standard.bool(forKey: isNotificationEnableKey)
    }
    

    
    func requestAuthorizationNotifications(){
        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    #warning("change the @Word@ argument to a CoreData object")
    func addNotification(for word: Word) {
        
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = word.original
            content.subtitle = word.translate
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        }
            
            self.center.getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        addRequest()
                    } else {
                        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                addRequest()
                            } else if let error = error {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
        }
}

