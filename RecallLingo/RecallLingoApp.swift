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
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    static let dataController = DataController()
    @StateObject var vm = DictViewModel(dataController:  dataController)
    @StateObject var lNManager = LocalNotificationManager(data:  dataController)
    @Environment(\.scenePhase) private var phase
    @State private var isPresented = false
    var body: some Scene {
        WindowGroup {
            MainScreen(isPresented: $isPresented)
                .environmentObject(vm)
                .environmentObject(lNManager)
                .environmentObject(Self.dataController)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                
                .task{
                    try? await lNManager.requestAuthorization()
                }
                .onChange(of: phase, perform: { newValue in
                    if newValue == .active {
                        Task{
                            try? await lNManager.getCurrentSetting()
                        }
                    }
                })
                .onChange(of: Self.dataController.savedEntities, perform: { newValue in
                    print("MostPopularWord: \(vm.mostPopularWord?.original ?? "") - \(vm.mostPopularWord?.popularity ?? 0)")
                })
            
            // Запускає нотифікацію після закриття додатку
            //                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            //        }
            //                            }
            
                
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    lNManager.addNotification(for: vm.mostPopularWord ?? WordEntity())
                        }
            
            //                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            //                    isPresented = true
            //                }
            //                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)){ _ in
            //                    isPresented = true
            //                }
            
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                        for notification in notifications {
                            if notification.request.content.categoryIdentifier == "myNotificationCategory" {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                break
                            }
                        }
                    }
                }
            
        }
    }
}
