//
//  WordRememberView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 11.05.2023.
//

import SwiftUI

struct WordRememberView: View {
    @EnvironmentObject var vm: DictViewModel
    @Environment(\.dismiss) var dismiss
    @State var word: WordEntity
    @State var translationUser: String = ""
    @State var isChecked = false
    @State var isCorrected: Bool?
    var translationCorrect: String{
        self.word.translate ?? ""
    }
    var body: some View {
        NavigationView {
            VStack {
                Text(word.original ?? "")
                    .font(.title)
                    .foregroundColor(.yellow)
                Text(word.translate ?? "")
                    .font(.title)
                    .foregroundColor(.blue)
                    .blur(radius: isChecked ? 0 : 3)
                TextField("Enter translation:", text: $translationUser)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isChecked)
                Button(){
                    checkTransltation()
                } label: {
                    Text("Check")
                }
                
            }
            .navigationTitle("Remember the translation")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label("RecallLingo", systemImage: "arrowshape.turn.up.backward")
                    }
                }
            }
        }
        
    }
    
    func checkTransltation(){
        isCorrected = translationUser == translationCorrect ? true : false
//        isCorrected ? vm.decreasePopularity(word: word) : vm.increasePopularity(word: word)
        isChecked = true

    }
    
}

//struct WordRememberView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordRememberView()
//    }
//}
