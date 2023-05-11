//
//  RecallLingoApp.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI
import Combine
import UserNotifications


@main
struct RecallLingoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    static let dataController = DataController()
    @StateObject var vm = DictViewModel(dataController:  dataController)
    @StateObject var notificationController = LocalNotificationController()
//    @Environment(\.scenePhase) private var phase
    @State private var isPresented = false
    var body: some Scene {
        WindowGroup {
            MainScreen(isPresented: $isPresented)
                .environmentObject(vm)
                .environmentObject(notificationController)
                .environmentObject(Self.dataController)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .onAppear(){
                    notificationController.requestAuthorizationNotifications()
                }
                
//                .onChange(of: phase) { newPhase in
//                    switch phase{
//
//                    case .background:
//                        print("background")
//                    case .inactive:
//                        print("inactive")
//                        let content = UNMutableNotificationContent()
//                        content.title = "Notification Title"
//                        content.subtitle = "Notification Subtitle"
//                        content.sound = UNNotificationSound.default
//
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                        UNUserNotificationCenter.current().add(request)
//                    case .active:
//                        print("active")
//                    @unknown default:
//                        print("default")
//                    }
//                }
            // Запускає нотифікацію після закриття додатку
            //                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
//        }
//
//                            }
            
                
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    notificationController.addNotification(for: vm.mostPopularWord ?? WordEntity())
                        }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    // Ваша дія
                    isPresented = true
                }
                
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
 
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
      UNUserNotificationCenter.current().delegate = self


      
      return true
    }

    
    
    
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("press Background")

//        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("press Foreground")

//        completionHandler([.sound, .badge, .banner, .list])
    }
    
    //    Працює
    //    func applicationWillTerminate(_ application: UIApplication) {
    //            let content = UNMutableNotificationContent()
    //            content.title = "Notification Title"
    //            content.subtitle = "Notification Subtitle"
    //            content.sound = UNNotificationSound.default
    //
    //            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    //            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    //
    //            UNUserNotificationCenter.current().add(request)
    //        }
}
