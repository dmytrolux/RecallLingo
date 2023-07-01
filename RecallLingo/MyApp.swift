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
                    lNManager.addNotification(for: word, delaySec: lNManager.interval, scheduledDate: nil)
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
