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
struct MyApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    static var dataController = DataController()
    @StateObject var lNManager = LocalNotificationManager()//
    @Environment(\.scenePhase) private var phase
    @State private var isPresented = false
    var body: some Scene {
        WindowGroup {
            MainScreen(isPresented: $isPresented)
                .preferredColorScheme(.dark)
                .environmentObject(lNManager)
                .environmentObject(Self.dataController)
            
                .onChange(of: phase, perform: { newValue in
                    if newValue == .active {
                        Task{
                            try? await lNManager.getCurrentSetting()
                        }
                    }
                })
            
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    guard let word = Self.dataController.mostPopularWord() else { return }
                    lNManager.addNotification(for: word, delaySec: 60*60*8, scheduledDate: nil)
                }
            
            
        }
        
    }
    
    init() {
        
        if UserDefaults.standard.object(forKey: UDKey.isGranted) == nil {
            UserDefaults.standard.register(defaults: [UDKey.isGranted: false])
        }
        if UserDefaults.standard.object(forKey: UDKey.isEnable) == nil {
            UserDefaults.standard.register(defaults: [UDKey.isEnable: false])
        }
        
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        UNUserNotificationCenter.current().delegate = self
//        return true
//    }
//}

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        if response.actionIdentifier == Action.know{
//            NotificationCenter.default.post(name: Notifications.pressToKnow, object: nil)
//        }
//        }
    
    
    

                
//                .task{
//                    try? await lNManager.requestAuthorization()
//                }
                
//                .onChange(of: Self.dataController.savedEntities, perform: { newValue in
//                    print("MostPopularWord: \(viewModel.mostPopularWord?.original ?? "") - \(viewModel.mostPopularWord?.popularity ?? 0)")
//                })
            
            // Запускає нотифікацію після закриття додатку
            //                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            //        }
            //                            }
            
                
                
            
            //                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            //                    isPresented = true
            //                }
            //                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)){ _ in
            //                    isPresented = true
            //                }
            
//                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//                    UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
//                        for notification in notifications {
//                            if notification.request.content.categoryIdentifier == "myNotificationCategory" {
//                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                                break
//                            }
//                        }
//                    }
//                }
            


