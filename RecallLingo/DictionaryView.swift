//
//  DictionaryView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct DictionaryView: View {
    @ObservedObject var vm: DictionaryViewModel
    var body: some View {
        NavigationView {
            List(vm.dict.sorted(by: { $0.key < $1.key }), id: \.key) { key, word in
                NavigationLink(destination: WordDetailView(viewModel: vm,
                                                           word: word)) {
                    HStack{
                        Image(systemName: "\(word.popularity).square.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                            
                        Spacer()
                            .frame(width: 20)
                        
                        Text("\(word.original.capitalized)")
                        
                    }
                            }
                        }
                        .navigationBarTitle("Dictionary")
        }
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView(vm: DictionaryViewModel(notificationsManager: LocalNotificationManager()))
    }
}

struct WordDetailView: View {
    @ObservedObject var viewModel: DictionaryViewModel
    @State var word: Word
    var body: some View {
        VStack {
            Text(word.original)
            Text(word.translate)
            Text("Popularity: \(word.popularity)")
            
            Button() {
               //Edit word
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
            
            
            Button() {
                viewModel.remove(this: word)
            } label: {
                Label("Delete", systemImage: "trash")
                    .foregroundColor(.red)
            }

        }
        .onAppear(){
            var mutableWord = word
            viewModel.increasePopularity(in: &mutableWord)
            self.word = mutableWord
        }
    }
}


struct WordView: View {
    let word: Word
    
    var body: some View {
        VStack {
            Text(word.original)
            Text(word.translate)
            Button("Зрозуміло") {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                exit(0)
            }
        }
    }
}
