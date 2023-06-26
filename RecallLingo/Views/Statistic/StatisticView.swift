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
        NavigationView{
            Form{
                Section{
                    HStack{
                        Text("All words:")
                        Spacer(minLength: 0)
                        Text(data.savedEntities.count.description)
                            .foregroundColor(.myYellow)
                    }
                    if MyApp.dataController.mostPopularWord() != nil{
                        HStack{
                            Text("Most popular word:")
                            Spacer(minLength: 0)
                            Text(MyApp.dataController.mostPopularWord()?.original ?? "nil")
                                .foregroundColor(.myYellow)
                        }
                    }
                   
                }
                .listRowBackground(Color.myPurple)
            }
            
            .background(Color.myPurpleDark)
//            .scrollContentBackground(.hidden)
            .navigationTitle("Statistic")
            .navigationBarTitleDisplayMode(.large)
            .clearListBackground()
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView()
    }
}
