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
        .background(Color.myPurpleDark)
        .onAppear(){
            MyApp.dataController.increasePopularity(word: word)
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
                    self.presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        MyApp.dataController.deleteWordAt(object: word)
//
                    }
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



