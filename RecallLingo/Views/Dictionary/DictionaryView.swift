//
//  DictionaryView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct DictionaryView: View {
    @EnvironmentObject var data: DataController
    @EnvironmentObject var vm: DictViewModel
    @State var sortByAlphabet: Bool = false
    
    var body: some View {
        NavigationView {
            List{
                ForEach(data.savedEntities, id: \.id) { word in
                    NavigationLink(destination: WordDetailView(word: word)) {
                        HStack{
                            Image(systemName: "\(word.popularity).square.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(width: 20)
                            Text("\(word.original?.capitalized ?? "")")
                        }
                    }
                }
                .onChange(of: sortByAlphabet) { newValue in
                    sortByAlphabet ? data.sortWordByAlphabet() : data.sortWordByDate()
                }
               
            }
            .navigationBarTitle("Dictionary")
        }
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}



//struct WordView: View {
//    let word: Word
//
//    var body: some View {
//        VStack {
//            Text(word.original)
//            Text(word.translate)
//            Button("Зрозуміло") {
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                exit(0)
//            }
//        }
//    }
//}
