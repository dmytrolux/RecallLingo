//
//  RecallLingoApp.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

@main
struct RecallLingoApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
    init() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
}
