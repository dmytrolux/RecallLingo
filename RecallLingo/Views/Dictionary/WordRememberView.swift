//
//  WordRememberView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 11.05.2023.
//

import SwiftUI

struct WordRememberView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var notificationController: LocalNotificationManager
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
            VStack{
                Form{
                    let headerOriginal = HStack{
                        Text("cOriginal")
                            .foregroundColor(.myPurpleLight)
                        Spacer()
                        SpeakerEngView(text: word?.original ?? "")
                    }
                    
                    Section(header: headerOriginal ){
                        ZStack{
                            Color.myPurple
                            Text(word?.original ?? "")
                                .font(.system(size: 30))
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.myYellow)
                                .frame(maxWidth: .infinity)
                                .frame(alignment: .center)
                                .padding()
                            
                        }
                        .frame(maxHeight: UIScreen.main.bounds.height / 4)
                    }
                    .listRowBackground(Color.myPurple)
                    
                    let headerTranslate = HStack{
                        Text("cTranslate")
                            .foregroundColor(.myPurpleLight)
                        Spacer()
                    }
                    
                    Section(header: headerTranslate ){
                        RememberTextField(text: $translationUser, actionSubmit: checkTransltation)
                            .disabled(isChecked)
                    }
                    .listRowBackground(Color.white)
                    
                    Section(){
                        HStack{
                            Spacer()
                            checkButton
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    Section{
                        Toggle("cShowHint", isOn: $isShowHint)
                            .foregroundColor(.white)
                        
                        if isShowHint{
                            HStack{
                                Text("cHint:")
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
                .background(Color.myPurpleDark)
                .clearListBackground()
                .tint(Color.myYellow)
                
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Label("cRecallLingo", systemImage: "arrowshape.turn.up.backward")
                        }
                    }
                }
                
                .navigationTitle("cRememberTranslation")
                .navigationBarTitleDisplayMode(.inline)
                
                .onAppear(){
                    notificationController.removeAllNotifications()
                }
            }
        }//navigation
        
        
    }//body
    
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
    
    var checkButton: some View{
        Button(){
            checkTransltation()
        } label: {
            Group{ if !isChecked{
                Label("cCheck", systemImage: "checkmark.circle.badge.questionmark")
            } else {
                if isCorrected ?? false{
                    Label("cCorrect", systemImage: "checkmark.circle")
                        .foregroundColor(.white)
                } else {
                    Label("cIncorrect", systemImage: "xmark.circle")
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
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3gen) 15.5"))
                        .previewDisplayName("iPhone SE (3gen)")
    }
}


struct SpeakerEngView: View{
    @StateObject var audioManager = AudioManager.shared
    @State var isSpeakingEng = false
    let text: String
    var body: some View{
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
            if !isSpeakingEng {
                audioManager.speakEng(text: text ){
                    isSpeakingEng = true
                }
            } else {
                audioManager.stopSpeaking()
            }
        }
    }
}
