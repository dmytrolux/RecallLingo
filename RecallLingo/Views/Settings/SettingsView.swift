//
//  SettingsView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct SettingsView: View {
//    @EnvironmentObject var vm: DictViewModel
//    @EnvironmentObject var data: DataController
    @EnvironmentObject var notificationController: LocalNotificationManager
    var body: some View {
        VStack{
            Button {
                MyApp.dataController.clearAllDict()
            } label: {
                Text("Clear dictionary")
            }

                Toggle("Show notification", isOn: $notificationController.isEnable)

            Button("Print Notifications") {
                
            }
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
