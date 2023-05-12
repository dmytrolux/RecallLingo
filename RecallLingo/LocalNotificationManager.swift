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
    
    private let isNotificationEnableKey = "isNotificationEnable"
    
    @Published var isGranted = false
    
    @Published var isNotificationEnable: Bool {
        didSet {
            UserDefaults.standard.set(isNotificationEnable, forKey: isNotificationEnableKey)
            if !isNotificationEnable{
                self.removeAllNotifications()
                
                
            }
        }
    }
    
    @Published var dataController: DataController
    @Published var isPresented = false
    
    init (data: DataController){
        self.dataController = data
        UserDefaults.standard.register(defaults: [isNotificationEnableKey: true])
        isNotificationEnable = UserDefaults.standard.bool(forKey: isNotificationEnableKey)
        super.init()
        center.delegate = self
        
    }
    
    var mostPopularWord: WordEntity?{
        let sortedEntities = dataController.savedEntities.sorted{$0.popularity > $1.popularity}
        let result = sortedEntities.first
        return result
    }
    
    
    
    
    
    func requestAuthorization() async throws{
        try await center.requestAuthorization(options: options)
        try await getCurrentSetting()
        self.isNotificationEnable = true
    }
    
    func getCurrentSetting() async throws{
        let curentSetting = await center.notificationSettings()
        isGranted = (curentSetting.authorizationStatus == .authorized)
        print("isGranted: \(isGranted)")
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
        
        guard isNotificationEnable, word.popularity > 0 else {return}
        
        
        let content = UNMutableNotificationContent()
        content.title = word.original ?? "Title: error"
        content.subtitle = word.translate ?? "Subtitle: error"
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
