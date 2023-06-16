//
//  MessageTranslate.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 19.05.2023.
//

import SwiftUI

struct MessageTranslateView: View{
    @ObservedObject var viewModel: TranslateViewModel
    var chatUnit: ChatUnit
    @State var animatedText = ""
    @State var widthText: CGFloat = 0
    @State var countRan = 0
    @State var isFirstApear = true
    @State var isEditingMessage = false
    
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
    
    var key: String{
        chatUnit.wordUser.toKey()
    }
    
    @State var isStored = false
    
    var body: some View {
        ZStack{
            
            HStack{
                Spacer()
                
                messageView
            }
            
            if !viewModel.isEditMode{
                bookmarkView
            }
            
        }
        .rotationEffect(.degrees(180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
        
        .onAppear {
            if isFirstApear{
                animateText(chatUnit.wordTranslate)
                isFirstApear = false
            }
            isStored = viewModel.isWordEntityStored(at: key)
        }
        
        .onChange(of: viewModel.wordRequest) { value in
            if viewModel.isEditMode{
                viewModel.bufferMessageTranslate = value
            }
        }
        .onChange(of: viewModel.isEditMode) { newValue in
            if !newValue{
                isEditingMessage = false
                viewModel.wordRequest = ""
                UITabBar.showTabBar()
            }
        }
        .onChange(of: isEditingMessage, perform: { newValue in
            if !newValue{
                animatedText = chatUnit.wordTranslate
            }
        })
    
        
    }
    
    var messageView: some View{
        Group{
            if isEditingMessage{
                Text(viewModel.bufferMessageTranslate)
            } else {
                HStack(){
                    Text(animatedText)
                    //hiden Text to get the width of this message
                        .background(
                            ZStack {
                                Text(chatUnit.wordTranslate)
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
            }
        }
        .frame(width: isEditingMessage ?  nil : widthText)
        .foregroundColor(.myPurple)
        .padding(padding)
        .frame(minWidth: minWidth)
        .background(
            ZStack{
                if viewModel.tapppedID == chatUnit.id {
                    Color.myWhite
                    RoundedRectangle(cornerRadius: 15).stroke(Color.myPurpleLight, lineWidth: 4)
                } else {
                    Color.myYellow
                }
            }
        )
        .cornerRadius(15)
        .frame(maxWidth: maxWidth, alignment: .trailing)
        
        .onLongPressGesture(minimumDuration: 0.3){
            viewModel.editing(this: chatUnit,
                              updateMessageStatus: {isEditingMessage = true})
        }
    }
    
    var bookmarkView: some View{
        HStack{
            Spacer()

            Button{
                isStored = viewModel.toggleWordDictionaryStatus(this: chatUnit)
            } label: {
                Image(systemName: isStored ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .frame(width: 20, height: 30, alignment: .center)
                        .foregroundColor(.myPurpleLight)
            }
            Spacer().frame(width: widthSubstrate)
        }
        
    }
    
    func resettingPropertiesEditing(){
        viewModel.clearTranslateData()
        isEditingMessage = false
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

