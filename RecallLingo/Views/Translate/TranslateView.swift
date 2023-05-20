//
//  TranslateView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView()
            .preferredColorScheme(.dark)
            .environmentObject(DictViewModel(dataController: DataController()))
    }
}

struct ChatReplica: Identifiable{
    var id: UUID
    var userWord: String
    var translate: String
}

struct TranslateView: View {
    @EnvironmentObject var vm: DictViewModel
    
    @State var messages: [ChatReplica] = [
        ChatReplica(id: UUID(), userWord: "Dog", translate: "Собака"),
        ChatReplica(id: UUID(), userWord: "Car", translate: "Автомобіль"),
        ChatReplica(id: UUID(), userWord: "Sky", translate: "Небо"),
        ChatReplica(id: UUID(), userWord: "The Lord of the Rings", translate: "Володар перснів")
    ]
    
    @State var bufferID = UUID()
    @State var tapppedID : UUID?
    @State var isEditMode = false
    @State var isContainInDict = false //make logica
    @State var bufferMessageTranslate = ""
    
    
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                
                ScrollView(showsIndicators: true){
                    ForEach(messages, id: \.id) { message in
                        
                        VStack{
                            if !message.translate.isEmpty || isEditMode{
                                MessageTranslate(message: message,
                                                 tappedIndex: $tapppedID,
                                                 isEditMode: $isEditMode,
                                                 bufferMessageTranslate: $bufferMessageTranslate)
                                
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
                            tapppedID = nil

                        } label: {
                            Image(systemName: "pencil.slash")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(.myPurpleLight)
                                .padding(.leading, 15)
                        }
                    }
                    //TextField
                    ZStack{
                        if vm.inputEn.isEmpty{
                            HStack{
                                Text("Enter word")
                                    .foregroundColor(.myPurpleLight)
                                Spacer()
                            }
                        }
                        TextField("", text: $vm.inputEn)
                            .disableAutocorrection(false)
                            .textSelection(.enabled)
                            .autocapitalization(.sentences)
                            
                            //onEditingChanged: { changed in
                        
                    }
                    .foregroundColor(.myPurpleDark)
                    .padding(.vertical, 10)
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

                            
                            guard let tapppedID else {print("error tapppedID") ; return}
                            if let index = messages.firstIndex(where: {$0.id == tapppedID}){
                                messages[index].translate = bufferMessageTranslate.capitalized
                        }
                            self.tapppedID = nil
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
        .onChange(of: tapppedID) { value in
            bufferMessageTranslate = ""
        }
        
        
        
    }
    
    
    
}





