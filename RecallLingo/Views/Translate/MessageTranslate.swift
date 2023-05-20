//
//  MessageTranslate.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 19.05.2023.
//

import SwiftUI

struct MessageTranslate: View{
    @EnvironmentObject var vm: DictViewModel
    
    var message: ChatReplica
    @Binding var tappedIndex: UUID?
    @Binding var isEditMode: Bool
    @State var animatedText = ""
    @State var width: CGFloat = 0
    
    @State var countRan = 0
    @State var isFirstOnApear = true
    @State var isEditMessage = false
    @Binding var bufferMessageTranslate: String
    
    var body: some View {
        
        HStack{
            Spacer()
            Group{
                if isEditMessage{
                    Text(bufferMessageTranslate)
                } else {
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
                                        )
                                        .hidden()
                                }
                                    .frame(width: .greatestFiniteMagnitude)
                            )
                        Spacer(minLength: 0)
                    }
                }
            }
            .frame(width: isEditMessage ?  nil : width)
            .foregroundColor(.myPurple)
            .padding(.horizontal)
            .frame(minWidth: UIScreen.main.bounds.width*(1/4), minHeight: 50)
            .background(
                ZStack{
                    tappedIndex == message.id ? Color.myWhite : Color.myYellow
                    
                    if tappedIndex == message.id {
                            RoundedRectangle(cornerRadius: 15).stroke(Color.myPurpleLight, lineWidth: 4)
                        }
                }
            )
            .cornerRadius(15)
            
            .frame(maxWidth: UIScreen.main.bounds.width*(3/4), alignment: .trailing)

            .onAppear {
                if isFirstOnApear{
                    animateText(message.translate)
                    isFirstOnApear = false
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
            if !isEditMode {
                resettingPropertiesEditing()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tappedIndex = message.id
                    isEditMode = true
                    isEditMessage = true
                    vm.inputEn = message.translate
                }
            }
        }
        .onChange(of: vm.inputEn) { value in
            if isEditMode{
                bufferMessageTranslate = value
            }
        }
        .onChange(of: isEditMode, perform: { newValue in
            if !newValue{
                isEditMessage = false
                vm.inputEn = ""
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
        isEditMode = false
        isEditMessage = false
        bufferMessageTranslate = ""
        tappedIndex = nil
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
        MessageTranslate(message: ChatReplica(id: UUID(),
                                              userWord: "Dog",
                                              translate: "Собака"),
                         tappedIndex: .constant(nil),
                         isEditMode: .constant(false),
                         bufferMessageTranslate: .constant("Hello"))
            .environmentObject(DictViewModel(dataController: DataController()))
    }
}
