//
//  MessageUser.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 30.05.2023.
//

import Combine
import SwiftUI

struct MessageUserView: View {
    @StateObject var audioManager = AudioManager.shared
    @StateObject var viewModel: TranslateViewModel
    var message: ChatUnit
    @State var widthText: CGFloat = 0
    @State var isSpeaking = false
    
    var padding: CGFloat = 15
    var flag: CGFloat = 40 + 10
    var minWidth = UIScreen.main.bounds.width*(1/4)
    var maxWidth = UIScreen.main.bounds.width*(3/4)
    
    var widthSubstrate: CGFloat{
        if widthText < minWidth - 30{
            return minWidth + 10 + flag
        } else {
            return widthText + (2 * padding) + 10 + flag
        }
    }
    
    private let newMessage = NotificationCenter.default.publisher(for: Notifications.newMessage)
    
    
    var body: some View {
        ZStack{
            
            HStack{
                Flag(emoji: "🇬🇧")
                
                messageView
                Spacer()
            }
            
            speakerView
        }
        .rotationEffect(.degrees(180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
        .onChange(of: viewModel.bufferID) { newValue in
            print(viewModel.bufferID.uuidString)
        }

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
            audioManager.speak(text: message.wordUser) {
                isSpeaking = true
            }
        }
    }
    
    var speakerView: some View{
        HStack{
            Spacer().frame(width: widthSubstrate )

            
                Image(systemName: "speaker.zzz")
                    .resizable()
                    .frame(width: 30, height: 25)
                        .foregroundColor(.myPurpleLight)
            Spacer()
        }
        .opacity(isSpeaking ? 1 : 0)
        .onChange(of: audioManager.isSpeaking, perform: { newValue in
            if !newValue{
                isSpeaking = newValue
            }
        })
        //TODO: - Display the voiceView (isSpeaking = true) when speaking a new word using Notifications
        //
//        .onReceive(newMessage, perform: { notification in
//            if let newMessages = notification.object as? ChatUnit {
//                if newMessages.wordUser == viewModel.wordRequest{
//                    isSpeaking = true
//                }
//
//            }
//        })
        .onTapGesture {
            audioManager.stopSpeaking()
        }

    }
    
}



