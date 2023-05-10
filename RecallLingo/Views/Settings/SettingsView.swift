//
//  SettingsView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: DictViewModel
    @EnvironmentObject var data: DataController
    @EnvironmentObject var notificationController: LocalNotificationController
    var body: some View {
        VStack{
            Button {
                data.clearAllDict()
            } label: {
                Text("Clear dictionary")
            }
            
//            Button(action: {
//                vm.sendNotification()
//            }, label: {
//                Text("Send Notification")
//            })
            
            Toggle("Show notification", isOn: $notificationController.isNotificationEnable)
            
            
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
