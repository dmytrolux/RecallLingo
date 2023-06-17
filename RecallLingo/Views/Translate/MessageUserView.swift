//
//  MessageUser.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 30.05.2023.
//

import SwiftUI

struct MessageUserView: View {
    @ObservedObject var audioManager = AudioManager.shared
    var message: ChatUnit
    @State var widthText: CGFloat = 0
    @State var isSpeaking = false
    var padding: CGFloat = 15
    var minWidth = UIScreen.main.bounds.width*(1/4)
    var maxWidth = UIScreen.main.bounds.width*(3/4)
    
    var widthSubstrate: CGFloat{
        if widthText < minWidth - 30{
            return minWidth + 10
        } else {
            return widthText + (2 * padding) + 10
        }
    }
    
    
    var body: some View {
        ZStack{
            
            HStack{
                messageView
                Spacer()
            }
            
            voiceView.opacity(isSpeaking ? 1 : 0)
        }
        .rotationEffect(.degrees(180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
    }
    
    var messageView: some View{
        HStack{
            Text(message.wordUser)
                .background(
                    ZStack {
                        Text(message.wordUser)
                            .background(GeometryReader { width in
                                Color.clear.onAppear {
                                    widthText = width.size.width
                                }
                            }
                            )
                            .hidden()
                    }
                        .frame(maxWidth: maxWidth - 30)
                        .frame(width: .greatestFiniteMagnitude)
                )
            
            Spacer(minLength: 0)
        }
        .frame(width:  widthText)
        .foregroundColor(.myYellow)
        .padding(padding)
        .frame(minWidth: minWidth)
        .background(Color.myPurple)
        .cornerRadius(15)
        .frame(maxWidth: maxWidth, alignment: .leading)
        
        .onTapGesture {
            if !isSpeaking {
                audioManager.speak(text: message.wordUser)
                self.isSpeaking = true
            }
        }
        
        .onChange(of: audioManager.synthesizer.isSpeaking) { isSpeaking in
            print("isSpeaking: \(isSpeaking)")
            if !isSpeaking {
                self.isSpeaking = false
            }
        }
        
        
    }
    
    var voiceView: some View{
        HStack{
            Spacer().frame(width: widthSubstrate )

            
                Image(systemName: "speaker.zzz")
                    .resizable()
                    .frame(width: 30, height: 25)
                        .foregroundColor(.myPurpleLight)
            Spacer()
        }
        .onTapGesture {
            audioManager.stopSpeaking()
        }
        
    }
}
