//
//  WordDetailView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 10.05.2023.
//

import SwiftUI

struct WordDetailView: View {
    @EnvironmentObject var vm: DictViewModel
    @State var word: WordEntity
    var body: some View {
        VStack {
            Text(word.original ?? "")
            Text(word.translate ?? "")
            Text("Popularity: \(word.popularity )")
            //date add
            
            Button() {
               //Edit word
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
            
            
            Button() {
                vm.removeAt(word: word)
            } label: {
                Label("Delete", systemImage: "trash")
                    .foregroundColor(.red)
            }

        }
        .onAppear(){
            vm.increasePopularity(word: word)
        }
    }
}

//struct WordDetailView_Previews: PreviewProvider {
//    @EnvironmentObject var vm: DictViewModel
//    static var previews: some View {
//        WordDetailView(word: )
//    }
//}
