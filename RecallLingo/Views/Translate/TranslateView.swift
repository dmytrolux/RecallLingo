//
//  TranslateView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

//struct TranslateView: View {
//    @EnvironmentObject var vm: DictViewModel
//    var body: some View {
//        NavigationView {
//        VStack {
//            TextField("", text: $vm.outputUk)
//                .textFieldStyle(.roundedBorder)
//                .accessibilityHint("Translated text")
//            Spacer()
//
//            if vm.isUniqueWord{
//                Button{
//                    vm.addToDictionary()
//                } label: {
//                    Label("Add to dictionary", systemImage: "plus.square")
//                        .padding(10)
//                        .overlay(){
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(Color.myPurpleLight, lineWidth: 1)
//                        }
//                        .padding(.bottom, 30)
//                }
//            }
//
//            HStack{
//                ZStack{
//                    if vm.outputUk.isEmpty{
//                        HStack{
//                            Text("Enter word")
//                                .foregroundColor(.myPurpleLight)
//                            Spacer()
//                        }
//
//                    }
//
//                    TextField("", text: $vm.outputUk)
//                }
//                .foregroundColor(.myPurpleDark)
//                .frame(height: 40)
//                .padding(.horizontal, 20)
//                .background(){
//                    RoundedRectangle(cornerRadius: 20)
//                }
//                .overlay(){
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color.myPurpleLight, lineWidth: 3)
//                }
//
//                .padding(.horizontal, 15)
//
//
//                Button {
//                    vm.translateText()
//                } label: {
//                    Image(systemName: "paperplane")
//                        .resizable()
//                        .frame(width: 30, height: 30, alignment: .center)
//                        .foregroundColor(.myPurpleLight)
//                        .padding(.trailing, 15)
//                }
//            }
//            .padding(.bottom, 20)
//        }
//        .background(Color.myPurpleDark)
//        .navigationTitle("Translate")
//
//    }
//
//    }
//
//
//}
//
//struct TranslateView_Previews: PreviewProvider {
//    static var previews: some View {
//        TranslateView()
//    }
//}




struct TranslateView: View {
    
    
    
    @EnvironmentObject var vm: DictViewModel
    
    @State var messages: [ChatReplica] = []
    @State var bufferID = UUID()
    @State var tapppedIndex =  UUID()
    @State var isEditMode = false
    @State var isContainInDict = false //make logica
    
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                
                ScrollView(showsIndicators: true){
                    ForEach(messages, id: \.id) { message in
                        
                        VStack{
                            if !message.translate.isEmpty{
                                MessageTranslate(message: message,
                                                 tappedIndex: $tapppedIndex,
                                                 isEditMode: $isEditMode)
                                
                            }
                            
                            HStack{
                                Text(message.userWord)
                                    .foregroundColor(.myYellow)
                                    .padding()
                                    .frame(minWidth: UIScreen.main.bounds.width*(1/4))
                                    .background(Color.myPurple)
                                    .cornerRadius(15)
                                    .frame(maxWidth: UIScreen.main.bounds.width*(3/4), alignment: .leading)
                                Spacer()
                            }
                            .rotationEffect(.degrees(180))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                        }
                        .cornerRadius(15)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 10)
                        
                    }
                }
                .rotationEffect(.degrees(180))
                .scaleEffect(x: -1, y: 1, anchor: .center)
                
                HStack(alignment: .center){
                    if isEditMode {
                        Button{
                            isEditMode = false
                        } label: {
                            Image(systemName: "pencil.slash")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.myPurpleLight)
                                .padding(.leading, 15)
                        }
                    }
                    
                    ZStack{
                        if vm.inputEn.isEmpty{
                            HStack{
                                Text("Enter word")
                                    .foregroundColor(.myPurpleLight)
                                Spacer()
                            }
                        }
                        TextField("", text: $vm.inputEn)
                    }
                    .foregroundColor(.myPurpleDark)
                    .frame(height: 40)
                    .padding(.horizontal, 20)
                    .background(){
                        RoundedRectangle(cornerRadius: 20)
                    }
                    .overlay(){
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.myPurpleLight, lineWidth: 3)
                    }
                    .padding(.horizontal, 15)
                    
                    if isEditMode{
                        Button {
                            isEditMode = false
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.myPurpleLight)
                                .padding(.trailing, 15)
                        }
                    } else {
                        Button {
                            vm.translateText()
                            let id = UUID()
                            let newMessages = ChatReplica(id: id, userWord: vm.inputEn, translate: "")
                            self.messages.insert(newMessages, at: 0)
                            bufferID = id
                            
                        } label: {
                            Image(systemName: "paperplane")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.myPurpleLight)
                                .padding(.trailing, 15)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color.myPurpleDark)
            .navigationTitle("Translate")
            
            
        }
        .onChange(of: vm.outputUk) { value in
            if !value.isEmpty{
                print(value)
                if let index = messages.firstIndex(where: {$0.id == bufferID}){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        messages[index].translate = value
                    }
                }
            }
        }
    }
    
    
    
}


struct AnimatedText: View {
    let text: String
    @State private var animatedText = ""
    
    var body: some View {
        ZStack {
            Text(text)
                .opacity(0)
            HStack{
                Text(animatedText)
                Spacer()
            }
        }
        .onAppear {
            animateText(text)
        }
    }
    
    func animateText(_ text: String) {
        guard !text.isEmpty else { return }
        
        let firstCharacter = String(text.prefix(1))
        let remainingText = String(text.dropFirst())
        
        animatedText += firstCharacter
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animateText(remainingText)
        }
    }
}

struct MessageTranslate: View{
    var message: ChatReplica
    @Binding var tappedIndex: UUID
    @Binding var isEditMode: Bool
    @State private var animatedText = ""
    @State var width: CGFloat = 0
    
    @State var countRan = 0
    @State var isFirstOnApear = true
    
    var body: some View {
        
        HStack{
            Spacer()
            
            HStack(){
                Text(animatedText)
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
            .frame(width: width)
            
            
            
            .foregroundColor(.myPurple)
            
            .padding()
            .frame(minWidth: UIScreen.main.bounds.width*(1/4))
            
            .background(
                tappedIndex == message.id ? Color.myPurpleLight : .myYellow
            )
            .cornerRadius(15)
            .frame(maxWidth: UIScreen.main.bounds.width*(3/4), alignment: .trailing)
            
            .onTapGesture {
                tappedIndex = message.id
                isEditMode = false
            }
            .onAppear {
                if isFirstOnApear{
                    animateText(message.translate)
                    isFirstOnApear = false
                }
            }
            
            if tappedIndex == message.id{
                HStack{
                    Button{
                        //isContainInDict.toggle()
                        
                    } label: {
                        Image(systemName: true ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .frame(width: 20, height: 30, alignment: .center)
                            .foregroundColor(.myPurpleLight)
                    }
                    .disabled(isEditMode)
                    
                    Button{
                        isEditMode = true
                    } label: {
                        Image(systemName: isEditMode ? "pencil.circle.fill" : "pencil.circle")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(.myPurpleLight)
                    }
                    
                }
            }
            
        }
        .rotationEffect(.degrees(180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
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

struct ChatReplica: Identifiable{
    var id: UUID
    var userWord: String
    var translate: String
}
