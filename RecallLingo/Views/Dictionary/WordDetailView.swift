//
//  WordDetailView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 10.05.2023.
//

import AVFoundation
import SwiftUI

struct WordDetailView: View {
    @State var word: WordEntity
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var audioManager = AudioManager.shared
    @State var isSpeakingEng = false
    @State var isSpeakingUkr = false
    @State var isEdit = false
    @State var translate = ""
    
    var body: some View {
        Form{
            let headerOriginal = HStack{
                Text("cOriginal")
                    .foregroundColor(.myPurpleLight)
                Spacer()
                speakerEng
            }
            
            Section(header: headerOriginal ){
                ZStack{
                    Color.myPurple
                    Text(word.original ?? "")
                        .font(.system(size: 30))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.myYellow)
                        .frame(maxWidth: .infinity)
                        .frame(alignment: .center)
                        .padding()
                    
                }
                .frame(height: UIScreen.main.bounds.height / 4)
                .onTapGesture {
                    audioManager.speakEng(text: word.original ?? ""){
                        isSpeakingEng = true
                    }
                }
            }
            .listRowBackground(Color.myPurple)
            
            let headerTranslate = HStack{
                
                Text("cTranslate")
                    .foregroundColor(.myPurpleLight)
                Spacer()
                speakerUkr
            }
            
            Section(header: headerTranslate){
                ZStack{
                    Color.myYellow
                    Text(word.translate ?? "")
                        .font(.system(size: 30))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.myPurple)
                        .frame(maxWidth: .infinity)
                        .frame(alignment: .center)
                        .padding()
                }
                .frame(height: UIScreen.main.bounds.height / 4)
                
                
            }
            .listRowBackground(Color.myYellow)
            
            Section{
                HStack{
                    Text("cPopularity:")
                    Spacer(minLength: 0)
                    Text(word.popularity.description)
                        .foregroundColor(.myYellow)
                }
                HStack{
                    Text("cDateAdded:")
                    Spacer(minLength: 0)
                    
                    Text(word.date ?? Date(), format: .dateTime)
                        .foregroundColor(.myYellow)
                }
            }
            .listRowBackground(Color.myPurple)
            
        }
        .background(Color.myPurpleDark)
        .clearListBackground()
        
        .onAppear(){
            translate = word.translate ?? ""
        }
        .navigationTitle("cWord")
        .navigationBarTitleDisplayMode(.inline)
        .alert("cEditTranslate", isPresented: $isEdit, actions: {
            TextField("cEditTranslate", text: $translate)
            
            Button("cSave", action: {
                isEdit = false
                word.translate = translate
                MyApp.dataController.saveData()
            })
            
            Button("cCancel", role: .cancel, action: {
                isEdit = false
            })
            
        }, message: {
            
            Text("cPleaseEnter".localized() + (word.original ?? "nil") + "\"")
        })
        
        
        .toolbar(){
            ToolbarItem(placement: .destructiveAction) {
                Button() {
                    self.presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        MyApp.dataController.deleteWordAt(object: word)
                    }
                } label: {
                    Label("cDelete", systemImage: "trash")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.red)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button() {
                    isEdit = true
                } label: {
                    Label("cEdit", systemImage: "square.and.pencil")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.myYellow)
                }
            }
        }
        
        
        .background(Color.myPurpleDark)
        .onAppear(){
            
            UITabBar.hideTabBar(animated: false)
            if audioManager.isAutoSpeak{
                audioManager.speakEng(text: word.original ?? ""){
                    isSpeakingEng = true
                }
            }
        }
        .onDisappear(){
            
            MyApp.dataController.increasePopularity(word: word)
            UITabBar.showTabBar(animated: true)
        }
        
        .background(Color.myPurpleDark)
        
    }
    
    var speakerEng: some View{
        ZStack{
            Image("bubbleSpeakerBack")
                .resizable()
                .scaleEffect(0.95)
            
            Image(isSpeakingEng ? "bubbleSpeakerOn" : "bubbleSpeakerOff")
                .resizable()
        }
                .frame(width: 20, height: 20)
                .scaleEffect(2)
                .offset(x: 0, y: 10)
                
                .onChange(of: audioManager.isSpeaking, perform: { newValue in
                    if !newValue{
                        isSpeakingEng = newValue
                    }
                })
                .onTapGesture {
                    if !isSpeakingEng && !isSpeakingUkr{
                        audioManager.speakEng(text: word.original ?? ""){
                            isSpeakingEng = true
                        }
                    } else {
                        audioManager.stopSpeaking()
                    }
                }
    }
    
    var speakerUkr: some View{
        ZStack{
            Image("bubbleSpeakerBack" )
                .resizable()
                .scaleEffect(0.95)
            Image(isSpeakingUkr ? "bubbleSpeakerUkrOn" : "bubbleSpeakerUkrOff")
                .resizable()
        }
        
        .frame(width: 20, height: 20)
        .scaleEffect(2)
        .offset(x: 0, y: 10)
                .onChange(of: audioManager.isSpeaking, perform: { newValue in
                    if !newValue{
                        isSpeakingUkr = newValue
                    }
                })
                .onTapGesture {
                    if !isSpeakingEng && !isSpeakingUkr{
                        audioManager.speakUkr(text: word.translate ?? ""){
                            isSpeakingUkr = true
                        }
                    } else {
                        audioManager.stopSpeaking()
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


    }
}

