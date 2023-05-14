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
            print("isNotificationEnable4: \(UserDefaults.standard.bool(forKey: UDKey.isEnable))")
            UserDefaults.standard.set(isGranted, forKey: UDKey.isGranted)
            
//            isEnable = isGranted
            print("isNotificationEnable4: \(UserDefaults.standard.bool(forKey: UDKey.isEnable))")
        }
    }
    
    @Published var isEnable: Bool {
        didSet {
            print("isNotificationEnable3: \(UserDefaults.standard.bool(forKey: UDKey.isEnable))")
            UserDefaults.standard.set(isEnable, forKey: UDKey.isEnable)
            
            if !isEnable{
                self.removeAllNotifications()
                
                
            }
            print("isNotificationEnable4: \(UserDefaults.standard.bool(forKey: UDKey.isEnable))")
        }
    }
    
    @Published var dataController: DataController
    @Published var isPresented = false
    
    init (data: DataController) {
        print("05: \n isNotification: \(UserDefaults.standard.bool(forKey: UDKey.isEnable)) \n isGranted: \(UserDefaults.standard.bool(forKey: UDKey.isGranted))")
        
        self.dataController = data
        
        isEnable = UserDefaults.standard.bool(forKey: UDKey.isEnable)
        isGranted = UserDefaults.standard.bool(forKey: UDKey.isGranted)
        
        print("06: \n isNotification: \(UserDefaults.standard.bool(forKey: UDKey.isEnable)) \n isGranted: \(UserDefaults.standard.bool(forKey: UDKey.isGranted))")
        
        super.init()
        center.delegate = self
    }
    
    var mostPopularWord: WordEntity?{
        let sortedEntities = dataController.savedEntities.sorted{$0.popularity > $1.popularity}
        let result = sortedEntities.first
        return result
    }
    
    func requestAuthorization() async throws{
        if !isGranted{
            try await center.requestAuthorization(options: options)
            try await getCurrentSetting()
            print("07: \n isNotification: \(UserDefaults.standard.bool(forKey: UDKey.isEnable)) \n isGranted: \(UserDefaults.standard.bool(forKey: UDKey.isGranted))")
        }
    }
    
    func getCurrentSetting() async throws{
        let curentSetting = await center.notificationSettings()
        isGranted = (curentSetting.authorizationStatus == .authorized)
        print("08: \n isNotification: \(UserDefaults.standard.bool(forKey: UDKey.isEnable)) \n isGranted: \(UserDefaults.standard.bool(forKey: UDKey.isGranted))")
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
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let _ = response.notification.request.content.userInfo["reminder"] as? String{
//            "Value: WordRememberView"
            self.isPresented = true
            
        }
    }
}
