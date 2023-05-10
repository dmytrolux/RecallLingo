//
//  RecallLingoApp.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

@main
struct RecallLingoApp: App {
    static let dataController = DataController()
    
    @StateObject var vm = DictViewModel(dataController:  dataController)
    @StateObject var notificationController = LocalNotificationController()
    @Environment(\.scenePhase) private var phase
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(vm)
                .environmentObject(Self.dataController)
                .environmentObject(notificationController)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .onChange(of: phase) { newPhase in
                    switch phase{
                        
                    case .background:
                        print("background")
                    case .inactive:
                        print("inactive")
                    case .active:
                        print("active")
                    @unknown default:
                        print("default")
                    }
                }
        }
    }

    init() {
        if notificationController.isNotificationEnable{
            notificationController.requestAuthorizationNotifications()
        }
    }
}
