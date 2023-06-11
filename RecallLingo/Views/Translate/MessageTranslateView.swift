//
//  MessageTranslate.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 19.05.2023.
//

import SwiftUI

struct MessageTranslateView: View{
    @StateObject var viewModel: TranslateViewModel
    var message: ChatReplica
    @State var animatedText = ""
    @State var width: CGFloat = 0
    @State var countRan = 0
    @State var isFirstApear = true
    @State var isEditMessage = false
    
    var body: some View {
        
        HStack{
            Spacer()
            Group{
                if isEditMessage{
                    Text(viewModel.bufferMessageTranslate)
                } else {
                    VStack{
                        HStack(){
                            Text(animatedText)
                            
                            //hiden Text to get the width of this message
                                .background(
                                    ZStack {
                                        Text(message.translate)
                                            .background(GeometryReader { fullGeo in
                                                Color.clear.onAppear {
                                                    width = fullGeo.size.width
                                                }
                                            }
                                            ).hidden()
                                    }
                                        .frame(maxWidth: UIScreen.main.bounds.width*(3/4)-30)
                                        .frame(width: .greatestFiniteMagnitude)
                                        
                                )
                            Spacer(minLength: 0)
                        }
                        Spacer(minLength: 0) 
                    }
                }
            }
            
            .frame(width: isEditMessage ?  nil : width)
            .foregroundColor(.myPurple)
            .padding()
            .frame(minWidth: UIScreen.main.bounds.width*(1/4))
            .background(
                ZStack{
                    viewModel.tapppedID == message.id ? Color.myWhite : Color.myYellow
                    
                    if viewModel.tapppedID == message.id {
                            RoundedRectangle(cornerRadius: 15).stroke(Color.myPurpleLight, lineWidth: 4)
                        }
                }
            )
            .cornerRadius(15)
            
            .frame(maxWidth: UIScreen.main.bounds.width*(3/4), alignment: .trailing)

            .onAppear {
                if isFirstApear{
                    animateText(message.translate)
                    isFirstApear = false
                }
            }
            
//            if tappedIndex == message.id{
//                HStack{
//                    Button{
//                        //isContainInDict.toggle()
//
//                    } label: {
//                        Image(systemName: true ? "bookmark.fill" : "bookmark")
//                            .resizable()
//                            .frame(width: 20, height: 30, alignment: .center)
//                            .foregroundColor(.myPurpleLight)
//                    }
//                    .disabled(isEditMode)
//
//                    Button{
//                        isEditMode = true
//                        isEditMessage = true
//                    } label: {
//                        Image(systemName: isEditMode ? "pencil.circle.fill" : "pencil.circle")
//                            .resizable()
//                            .frame(width: 30, height: 30, alignment: .center)
//                            .foregroundColor(.myPurpleLight)
//                    }
//
//                }
//            }
            
        }
        .onLongPressGesture(minimumDuration: 0.3){
            if !viewModel.isEditMode {
                resettingPropertiesEditing()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    viewModel.editing(this: message)
                    
                    isEditMessage = true
                }
            }
        }
        .onChange(of: viewModel.wordRequest) { value in
            if viewModel.isEditMode{
                viewModel.bufferMessageTranslate = value
            }
        }
        .onChange(of: viewModel.isEditMode, perform: { newValue in
            if !newValue{
                isEditMessage = false
                viewModel.wordRequest = ""
            }
        })
        .onChange(of: isEditMessage, perform: { newValue in
            if !newValue{
                animatedText = message.translate
            }
        })
        .rotationEffect(.degrees(180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
    }
    
    func resettingPropertiesEditing(){
        viewModel.clearTranslateData()
        isEditMessage = false
    }
    
    func animateText(_ text: String) {
        guard !text.isEmpty else { return }
        
        let firstCharacter = String(text.prefix(1))
        let remainingText = String(text.dropFirst())
        
        animatedText += firstCharacter
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            animateText(remainingText)
        }
    }
    
}

struct MessageTranslate_Previews: PreviewProvider {
    static var previews: some View {
        MessageTranslateView(viewModel: TranslateViewModel(),
                         message: ChatReplica(id: UUID(),
                                              userWord: "Dog",
                                              translate: "Собака")
                         )
    }
}
