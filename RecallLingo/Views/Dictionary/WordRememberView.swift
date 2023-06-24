//
//  WordRememberView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 11.05.2023.
//

import SwiftUI

struct WordRememberView: View {
    @Environment(\.dismiss) var dismiss
    let data = MyApp.dataController
    @State var word: WordEntity?
    @State var translationUser: String = ""
    @State var isChecked = false
    @State var isCorrected: Bool?
    @State var isShowHint = false
    var translationCorrect: String{
        self.word?.translate ?? ""
    }
    var body: some View {
        NavigationView {
            VStack {
                
                VStack{
                    HStack{
                        Spacer(minLength: 0)
                        Text(word?.original ?? "")
                            .font(.title)
                            .foregroundColor(.yellow)
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical)
                    .background(){
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.myPurple)
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.bottom, 15)
                    
                RememberTextField(text: $translationUser, actionSubmit: checkTransltation)
                    .disabled(isChecked)
                    .padding(.bottom, 15)
                    
                Button(){
                    checkTransltation()
                } label: {
                    Group{ if !isChecked{
                        Label("Check", systemImage: "checkmark.circle.badge.questionmark")
                    } else {
                        if isCorrected ?? false{
                            Label("Correct", systemImage: "checkmark.circle")
                                .foregroundColor(.white)
                        } else {
                            Label("Incorrect", systemImage: "xmark.circle")
                                .foregroundColor(.white)
                            
                        }
                            
                    }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(){
                        ZStack{
                            if isChecked{
                                if isCorrected ?? false{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.green)
                                } else {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.red)
                                }
                            }
                            
                            
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.myPurpleLight, lineWidth: 1)
                        }
                    }
                }
                .disabled(isChecked)
                
                Form{
                    Section{
                        Toggle("Show Hint", isOn: $isShowHint)
                            .foregroundColor(.white)
                        
                        if isShowHint{
                            HStack{
                                Text("Hint:")
                                    .foregroundColor(.white)
                                
                                Spacer(minLength: 0)
                                
                                Text(word?.translate ?? "")
                                    .foregroundColor(.yellow)
                                    .blur(radius: isChecked ? 0 : 2)
                            }
                            
                        }
                        
                    }
                    .listRowBackground(Color.myPurple)
                }
                .tint(Color.myYellow)
                .background(Color.myPurpleDark)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Remember the translation")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.myPurpleDark)
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
        .background(Color.myPurpleDark)
        
    }
    
    func checkTransltation(){
        isCorrected = translationUser.toKey() == translationCorrect.toKey() ? true : false
        if let isCorrected, let word{
            if isCorrected{
                data.resetPopularity(word: word)
            } else {
                data.increasePopularity(word: word)
            }
        }
        
        isShowHint = true
        isChecked = true

    }
    
}

struct WordRememberView_Previews: PreviewProvider {
    static let dataController = DataController()
        static let word: WordEntity = {
            let newWord = WordEntity(context: dataController.container.viewContext)
            newWord.date = Date()
            newWord.id = "thelordoftherings"
            newWord.original = "Word"
            newWord.popularity = Int16(15)
            newWord.translate = "Слово"
            return newWord
        }()
    static var previews: some View {
        WordRememberView(word: word)
            .preferredColorScheme(.dark)
    }
}
