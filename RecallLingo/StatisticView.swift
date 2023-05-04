//
//  StatisticView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct StatisticView: View {
    @ObservedObject var vm: DictionaryViewModel
    
    var body: some View {
        Text("All words: \(vm.dict.count)")
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(vm: DictionaryViewModel(notificationsManager: LocalNotificationManager()))
    }
}
