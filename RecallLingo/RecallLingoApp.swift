//
//  RecallLingoApp.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

@main
struct RecallLingoApp: App {
    let dataController = DataController()
//    @StateObject var dataController = DataController()
    @StateObject var vm = DictionaryViewModel(dataController: DataController())
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
//                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(vm)
        }
    }
    init() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
