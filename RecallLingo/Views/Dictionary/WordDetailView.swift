//
//  WordDetailView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 10.05.2023.
//

import AVFoundation
import HidableTabView
import SwiftUI



struct WordDetailView: View {
    @State var word: WordEntity
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var audioManager = AudioManager.shared
    @State var isSpeaking = false
    @State var isEdit = false
    @State var translate = ""
    
    var body: some View {
            VStack {
                Form{
                    Section{
                        HStack{
                            Text("Popularity:")
                            Spacer(minLength: 0)
                            Text(word.popularity.description)
                                .foregroundColor(.myYellow)
                        }
                        HStack{
                            Text("Date added:")
                            Spacer(minLength: 0)
                            
                            Text(word.date ?? Date(), format: .dateTime)
                                .foregroundColor(.myYellow)
                        }
                    }
                    .listRowBackground(Color.myPurple)
                }
                .background(Color.myPurpleDark)
                .scrollContentBackground(.hidden)
                
                
                .background(Color.myPurpleDark)
                .scrollContentBackground(.hidden)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 15).fill(Color.myPurple)
                    Text(word.original ?? "")
                        .font(.title)
                        .foregroundColor(.myYellow)
                        .padding()
                    HStack{
                        Spacer()
                        VStack{
                            Spacer().frame(height: 10)
                            Button{
                                if !isSpeaking{
                                    audioManager.speak(text: word.original ?? "")
                                    isSpeaking = true
                                } else {
                                    audioManager.stopSpeaking()
                                }
                            } label: {

                                Image(systemName: isSpeaking ? "speaker.wave.2.bubble.left" : "speaker.wave.2.bubble.left.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.myYellow)
                                    .onChange(of: audioManager.isSpeaking, perform: { newValue in
                                        if !newValue{
                                            isSpeaking = newValue
                                        }
                                    })
                            }
                            Spacer()
                        }
                        Spacer().frame(width: 10)
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 15).fill(Color.yellow)
                    Text(word.translate ?? "")
                        .font(.title)
                        .foregroundColor(.myPurple)
                        .padding()
                }
                
                
                
            }
            .onAppear(){
                translate = word.translate ?? ""
            }
            .navigationTitle("Word")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Edit translate", isPresented: $isEdit, actions: {
                TextField("Edit translate", text: $translate)
                
                Button("Save", action: {
                    isEdit = false
                    word.translate = translate
                    MyApp.dataController.saveData()
                })
                
                Button("Cancel", role: .cancel, action: {
                    isEdit = false
                })
            
                    }, message: {
                        Text("Please enter a new translation for the word \"\(word.original ?? "nil")\"")
                    })

            
            .toolbar(){
                ToolbarItem(placement: .destructiveAction) {
                    Button() {
                        self.presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            MyApp.dataController.deleteWordAt(object: word)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.red)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button() {
                        isEdit = true
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.myYellow)
                    }
                }
            }

            
            .background(Color.myPurpleDark)
            .onAppear(){
                MyApp.dataController.increasePopularity(word: word)
                UITabBar.hideTabBar(animated: false)
            }
            .onDisappear(){
                print("Disappear")
            }
            
        .background(Color.myPurpleDark)
        
    }
}

//struct WordDetailView_Previews: PreviewProvider {
//    static let dataController = DataController()
//    static let word: WordEntity = {
//        let newWord = WordEntity(context: dataController.container.viewContext)
//        newWord.date = Date()
//        newWord.id = "thelordoftherings"
//        newWord.original = "The Lord of the Rings"
//        newWord.popularity = Int16(15)
//        newWord.translate = "Володар перснів"
//        return newWord
//    }()
//    static var previews: some View {
//        WordDetailView(word: word)
//            .preferredColorScheme(.dark)
//            .environmentObject(DictViewModel(dataController: DataController()))
//
//
//    }
//}



