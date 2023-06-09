//
//  TranslateView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

//struct TranslateView_Previews: PreviewProvider {
//    static var previews: some View {
//        TranslateView()
//            .preferredColorScheme(.dark)
//            .environmentObject(DictViewModel(dataController: DataController()))
//    }
//}

struct ChatReplica: Identifiable{
    var id: UUID
    var userWord: String
    var translate: String
}

struct TranslateView: View {
    @EnvironmentObject var vm: DictViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView(showsIndicators: true){
                    ForEach(vm.messages, id: \.id) { message in
                            VStack{
                                if !message.translate.isEmpty || vm.isEditMode{
                                    MessageTranslate(message: message,
                                                     tappedIndex: $vm.tapppedID,
                                                     isEditMode: $vm.isEditMode,
                                                     bufferMessageTranslate: $vm.bufferMessageTranslate)
                                }
                                
                                MessageUser(message: message)
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 10)
                        }
                }
               
                .rotationEffect(.degrees(180))
                .scaleEffect(x: -1, y: 1, anchor: .center)
                .onTapGesture {
                    hideKeyboard()
                }
                
                //Chat Panel
                HStack(alignment: .center){
                    
                    if vm.isEditMode {
                       editCancelView
                    }
                    
                    CustomTextField()
                    
                    if vm.isEditMode{
                        editDoneView
                    } else {
                        translationSendButtonView
                    }
                    
                }
                .padding(.bottom, 20)
            }
            .background(Color.myPurpleDark)
            .navigationTitle("Translate")
            .alert(item: $vm.isShowAlert){ show in
                Alert(title: Text("Error"),
                      message: Text(show.name),
                      dismissButton: .cancel())
            }
            
        }
        
//        if we received a response, we display it in the chat window on the user's message
        .onChange(of: vm.wordResponse) { response in
            vm.sendTranslatedMessage(response: response)
        }
        .onChange(of: vm.tapppedID) { value in
            vm.bufferMessageTranslate = ""
        }
        
    }
    
    var editCancelView: some View{
        Button{
            vm.clearTranslateData()
            vm.isEditMode = false
            vm.tapppedID = nil
            
        } label: {
            Image(systemName: "pencil.slash")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.myPurpleLight)
                .padding(.leading, 15)
        }
    }
    
    var editDoneView: some View{
        Button {
            guard let tapppedID = vm.tapppedID else {print("error tapppedID") ; return}
            if let index = vm.messages.firstIndex(where: {$0.id == vm.tapppedID}){
                vm.messages[index].translate = vm.bufferMessageTranslate.capitalized
                vm.editTranslationThisWord(to: vm.bufferMessageTranslate)
                //продовження є, звязати їх
                
            }
            vm.tapppedID = nil
            vm.isEditMode = false
            
        } label: {
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.myPurpleLight)
                .padding(.trailing, 15)
        }
    }
    
    var translationSendButtonView: some View{
        Button {
            vm.translateText()
            let id = UUID()
            let newMessages = ChatReplica(id: id, userWord: vm.wordRequest, translate: "")
            vm.messages.insert(newMessages, at: 0)
            vm.bufferID = id
            
        } label: {
            Image(systemName: "paperplane")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(vm.networkMonitor.isConnected ? .myPurpleLight : .red )
                .padding(.trailing, 15)
        }
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    
}





