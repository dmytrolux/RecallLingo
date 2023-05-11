//
//  LocalNotificationController.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.05.2023.
//

import Foundation
import UserNotifications

//в цьому класі прописати все, що стосується саме нотифікацій: від дозволу до їх планувальника
@MainActor
class LocalNotificationController: ObservableObject {
    
    private let center = UNUserNotificationCenter.current()
    
    private let isNotificationEnableKey = "isNotificationEnable"
    
    var isNotificationEnable: Bool {
        didSet {
            UserDefaults.standard.set(isNotificationEnable, forKey: isNotificationEnableKey)
            if !isNotificationEnable{
                self.removeAllNotifications()
            }
        }
    }
 
    
    init (){
        UserDefaults.standard.register(defaults: [isNotificationEnableKey: false])
        isNotificationEnable = UserDefaults.standard.bool(forKey: isNotificationEnableKey)
    }
    
    func requestAuthorizationNotifications() {
        if !isNotificationEnable{
            self.center.getNotificationSettings { settings in
                if settings.authorizationStatus == .notDetermined{
                    self.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if granted{
                            self.isNotificationEnable = true
                        }
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    
    func addNotification(for word: WordEntity) {
        guard isNotificationEnable, word.popularity > 0 else {return}
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = word.original ?? "Title: error"
            content.subtitle = word.translate ?? "Subtitle: error"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            self.removeAllNotifications()
            self.center.add(request)

        }
            requestNotificationAuthorization(completion: addRequest)
        }
    
        private func requestNotificationAuthorization(completion: @escaping () -> Void) {
        self.center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    completion()
                } else {
                    self.center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            self.isNotificationEnable = true
                            completion()
                        } else if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        
    }
    
    private func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}


