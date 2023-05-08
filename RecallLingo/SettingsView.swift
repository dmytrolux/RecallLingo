//
//  SettingsView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: DictionaryViewModel
    var body: some View {
        VStack{
            Button {
                vm.dict.removeAll()
            } label: {
                Text("Clear dictionary")
            }
            
//            Button(action: {
//                vm.sendNotification()
//            }, label: {
//                Text("Send Notification")
//            })
            
//            Toggle("Show notification", isOn: $vm.notificationsManager.isNotificationEnable)
//
            
            Button("Print Notifications") {
                vm.printNotification()
            }
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DictionaryViewModel(dataController: DataController()))
    }
}
