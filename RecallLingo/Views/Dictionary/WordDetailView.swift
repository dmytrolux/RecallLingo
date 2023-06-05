//
//  WordDetailView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 10.05.2023.
//

import HidableTabView
import SwiftUI

struct WordDetailView: View {
    @EnvironmentObject var vm: DictViewModel
    @State var word: WordEntity
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            Text(word.original ?? "")
                .font(.title)
            Text(word.translate ?? "")
                .font(.title)
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
            UITabBar.hideTabBar(animated: false)
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading:
                                Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
            Label("Dictionary" , systemImage: "chevron.backward.circle.fill")
//                                    Text("↩️ Dictionary")
                                }
               )
        .toolbar(){
            ToolbarItem(placement: .destructiveAction) {
                Button() {
                    vm.removeAt(word: word)
                } label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }

}

struct WordDetailView_Previews: PreviewProvider {
    static let dataController = DataController()
    static let word: WordEntity = {
        let newWord = WordEntity(context: dataController.container.viewContext)
        newWord.date = Date()
        newWord.id = "thelordoftherings"
        newWord.original = "The Lord of the Rings"
        newWord.popularity = Int16(15)
        newWord.translate = "Володар перснів"
        return newWord
    }()
    static var previews: some View {
        WordDetailView(word: word)
            .preferredColorScheme(.dark)
            .environmentObject(DictViewModel(dataController: DataController()))
            
        
    }
}
