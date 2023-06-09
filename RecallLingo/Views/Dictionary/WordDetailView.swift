//
//  WordDetailView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 10.05.2023.
//

import AVFoundation
import HidableTabView
import SwiftUI

enum Voice: String {
    case gordon = "com.apple.ttsbundle.siri_male_en-AU_compact"
    case karen = "us-female"
    case catherine = "uk-male"
    case ukFemale = "uk-female"
    case australian = "australian"
}

struct WordDetailView: View {
    @EnvironmentObject var vm: DictViewModel
    @State var word: WordEntity
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let synthesizer = AVSpeechSynthesizer()
    
    func speakWord(word: WordEntity){
//        if counter.volumeSpeakCount > 0 {
        print(AVSpeechSynthesisVoice.speechVoices())
        let utterance = AVSpeechUtterance(string: String(word.original ?? ""))
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-AU_compact")
            utterance.volume = 1
        utterance.rate = 0.4
            synthesizer.speak(utterance)
//        }
    }
    
    var body: some View {
        VStack {
            Text("Popularity: \(word.popularity )")
            Text(word.date ?? Date(), format: .dateTime)
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
                            speakWord(word: word)
                        } label: {
                            Image(systemName: "speaker.wave.3.fill")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.myYellow)
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
        .background(Color.myPurpleDark)
        .onAppear(){
            vm.increasePopularity(word: word)
            UITabBar.hideTabBar(animated: false)
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading:
                                Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
            Label("Dictionary" , systemImage: "chevron.backward.circle.fill")
                .font(.title3)
                .labelStyle(.titleAndIcon)
                .foregroundColor(.yellow)
                .frame(width: UIScreen.main.bounds.width*0.4, height: 40)
                .overlay(){
                    RoundedRectangle(cornerRadius: 15).stroke(Color.myYellow, lineWidth: 1)
                }
            
        }
        )
        
        .toolbar(){
            ToolbarItem(placement: .destructiveAction) {
                Button() {
                    vm.removeAt(word: word)
                } label: {
                    Label("Delete", systemImage: "trash")
                        .font(.title3)
                        .labelStyle(.titleAndIcon)
                        .foregroundColor(.red)
                        .frame(width: UIScreen.main.bounds.width*0.4, height: 40)
                        .overlay(){
                            RoundedRectangle(cornerRadius: 15).stroke(Color.red, lineWidth: 1)
                        }
                    
                }
            }
        }
        
        .toolbar(){
            ToolbarItem(placement: .confirmationAction) {
                Button() {
                    //Edit word
                } label: {
                    Label("Edit", systemImage: "square.and.pencil")
                        .font(.title3)
                        .labelStyle(.titleAndIcon)
                        .foregroundColor(.red)
                        .frame(width: UIScreen.main.bounds.width*0.4, height: 40)
                        .overlay(){
                            RoundedRectangle(cornerRadius: 15).stroke(Color.red, lineWidth: 1)
                        }
                }
            }
        }
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



