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
    
    static let dataController = DataController()
//    @StateObject var viewModel = DictViewModel()//
    @StateObject var lNManager = LocalNotificationManager()//
    @Environment(\.scenePhase) private var phase
    @State private var isPresented = false
    var body: some Scene {
        WindowGroup {
            MainScreen(isPresented: $isPresented)
                .preferredColorScheme(.dark)
//                .environmentObject(viewModel)
                .environmentObject(lNManager)
                .environmentObject(Self.dataController)
                
                .onChange(of: phase, perform: { newValue in
                    if newValue == .active {
                        Task{
                            try? await lNManager.getCurrentSetting()
                            
                        }
                    }
                })
                
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
            
                
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    lNManager.addNotification(for: Self.dataController.mostPopularWord() ?? WordEntity())
                        }
            
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
            
        }
    }
    
    init() {
        print("05: \n isNotification: \(UserDefaults.standard.bool(forKey: UDKey.isEnable)) \n isGranted: \(UserDefaults.standard.bool(forKey: UDKey.isGranted))")
        if UserDefaults.standard.object(forKey: UDKey.isGranted) == nil {
            UserDefaults.standard.register(defaults: [UDKey.isGranted: false])
        }
        if UserDefaults.standard.object(forKey: UDKey.isEnable) == nil {
            UserDefaults.standard.register(defaults: [UDKey.isEnable: false])
        }
        print("07: \n isNotification: \(UserDefaults.standard.bool(forKey: UDKey.isEnable)) \n isGranted: \(UserDefaults.standard.bool(forKey: UDKey.isGranted))")
        
    }
}

