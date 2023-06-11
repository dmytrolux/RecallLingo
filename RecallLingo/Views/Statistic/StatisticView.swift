//
//  StatisticView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct StatisticView: View {
    @EnvironmentObject var data: DataController
    @EnvironmentObject var vm: TranslateViewModel
    var body: some View {
        VStack{
            Text("All words: \(data.savedEntities.count)")
            Text("Most Popular Word: \(MyApp.dataController.mostPopularWord()?.original ?? "nil")") //замінити на RecallLingo
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView()
    }
}
