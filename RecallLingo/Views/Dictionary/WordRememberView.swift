//
//  WordRememberView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 11.05.2023.
//

import SwiftUI

struct WordRememberView: View {
    @EnvironmentObject var vm: DictViewModel
    @State var word: WordEntity
    var body: some View {
        VStack {
            Text(word.original ?? "")
                .font(.title)
                .foregroundColor(.yellow)
            Text(word.translate ?? "")
                .font(.title)
                .foregroundColor(.blue)
        }
        .onAppear(){
            vm.decreasePopularity(word: word)
        }
    }
}

//struct WordRememberView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordRememberView()
//    }
//}
