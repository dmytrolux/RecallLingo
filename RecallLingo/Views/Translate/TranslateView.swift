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
    
    @State var bufferID = UUID()
    @State var tapppedID : UUID?
    @State var isEditMode = false
    @State var isContainInDict = false //make logica
    @State var bufferMessageTranslate = ""
//    @State private var keyboardOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView(showsIndicators: true){
                    ForEach(vm.messages, id: \.id) { message in
                            VStack{
                                if !message.translate.isEmpty || isEditMode{
                                    MessageTranslate(message: message,
                                                     tappedIndex: $tapppedID,
                                                     isEditMode: $isEditMode,
                                                     bufferMessageTranslate: $bufferMessageTranslate)
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
                    
                    if isEditMode {
                       editCancelView
                    }
                    
                    CustomTextField()
                    
                    if isEditMode{
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
        .onChange(of: vm.translateResponse) { response in
            if !response.isEmpty{
                print("Переклад: \(response)")
                if let index = vm.messages.firstIndex(where: {$0.id == bufferID}){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        vm.messages[index].translate = response
                        vm.clearTextFields()
                    }
                } else {
                    print("ereor index")
                }
            }
        }
        .onChange(of: tapppedID) { value in
            bufferMessageTranslate = ""
        }
//        .onChange(of: vm.inputEn) { value in
//            print("inputEn: \(value)")
//        }
        
    }
    
    var editCancelView: some View{
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
    
    var editDoneView: some View{
        Button {
            guard let tapppedID else {print("error tapppedID") ; return}
            if let index = vm.messages.firstIndex(where: {$0.id == tapppedID}){
                vm.messages[index].translate = bufferMessageTranslate.capitalized
                vm.editTranslationThisWord(to: bufferMessageTranslate)
                
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
    }
    
    var translationSendButtonView: some View{
        Button {
            vm.translateText()
            let id = UUID()
            let newMessages = ChatReplica(id: id, userWord: vm.translateRequest, translate: "")
            vm.messages.insert(newMessages, at: 0)
            bufferID = id
            
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





