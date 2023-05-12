//
//  StatisticView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct StatisticView: View {
    @EnvironmentObject var data: DataController
    @EnvironmentObject var vm: DictViewModel
    var body: some View {
        VStack{
            Text("All words: \(data.savedEntities.count)")
            Text("Most Popular Word: \(vm.mostPopularWord?.original ?? "nil")")
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView()
    }
}
