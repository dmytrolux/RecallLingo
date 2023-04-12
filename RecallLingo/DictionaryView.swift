//
//  DictionaryView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct DictionaryView: View {
    @ObservedObject var viewModel: WordsModel
    var body: some View {
        NavigationView {
            //Виведи List всіх наявних Word у словнику dict
            List(viewModel.dict.sorted(by: { $0.key < $1.key }), id: \.key) { key, word in
                            NavigationLink(destination: WordDetailView(word: word)) {
                                Text(key)
                            }
                        }
                        .navigationBarTitle("Dictionary")
        }
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView(viewModel: WordsModel())
    }
}

struct WordDetailView: View {
    let word: Word
    var body: some View {
        VStack {
            Text(word.original)
            Text(word.translate)
            Text("Popularity: \(word.popularity)")
        }
//        .navigationBarTitle(word.original)
    }
}
