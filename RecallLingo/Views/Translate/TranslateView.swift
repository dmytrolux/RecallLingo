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
    }
}

struct TranslateView: View {
    @StateObject var viewModel = TranslateViewModel()
    @StateObject var audioManager = AudioManager.shared
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollViewReader { scrollViewProxy in
                    //how
                    ScrollView(showsIndicators: true){
                        ForEach(viewModel.chat, id: \.id) { chatUnit in
                            ChatUnitView(viewModel: viewModel,
                                         chatUnit: chatUnit)
                            .id(chatUnit.id)
                        }
                        .onChange(of: viewModel.chat) { _ in
                            // Scroll to the bottom whenever the chat array changes
                            withAnimation {
                                scrollViewProxy.scrollTo(viewModel.chat.first?.id, anchor: .bottom)
                            }
                        }
                      
                        
                    }
                    .rotationEffect(.degrees(180))
                    .scaleEffect(x: -1, y: 1, anchor: .center)
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
                
                //Chat Panel
                HStack(alignment: .center){
                    
                    if viewModel.isEditMode {
                        editCancelButtonView
                    } else {
                        speakerButtonView
                    }
                    
                    CustomTextField(vm: viewModel)
                    
                    if viewModel.isEditMode{
                        editDoneButtonView
                    } else {
                        sendMessageForTranslationButtonView
                        
                    }
                    
                }
                .padding(.bottom, 20)
            }
            .background(Color.myPurpleDark)
            .navigationTitle("Translate")
            .navigationBarHidden(viewModel.isHidenTitle)
            // open keyboard hide navigationTitle
            
            
            
            .alert(item: $viewModel.isShowAlert){ show in
                Alert(title: Text("Error"),
                      message: Text(show.name),
                      dismissButton: .cancel())
            }
            
        }
        
        
        //        if we received a response, we display it in the chat window on the user's message
        .onChange(of: viewModel.wordResponse) { response in
            viewModel.sendTranslatedMessage(response: response)
        }
        
        

        
    }
    
    var editCancelButtonView: some View{
        Button{
            viewModel.clearTranslateData()
            viewModel.isEditMode = false
            viewModel.tapppedID = nil
            
        } label: {
            Image(systemName: "pencil.slash")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.myPurpleLight)
                .padding(.leading, 15)
        }
    }
    
    var editDoneButtonView: some View{
        Button {
            viewModel.finishEditingTranslationThisWord()
            
        } label: {
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.myPurpleLight)
                .padding(.trailing, 15)
                .opacity(viewModel.isEditDoneViewDisabled ? 0.5 : 1)
        }
        .disabled(viewModel.isEditDoneViewDisabled)
    }
    
    var sendMessageForTranslationButtonView: some View{
        Button {
            if !viewModel.wordRequest.isEmpty{
                viewModel.sendMessageForTranslation()
                
                if !audioManager.isMute{
                    audioManager.speak(text: viewModel.wordRequest)
                }
            }
        } label: {
            Image(systemName: "paperplane")
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(viewModel.networkMonitor.isConnected ? .myPurpleLight : .red )
                .padding(.trailing, 15)
                .opacity(viewModel.isSendMessageButtonDisabled ? 0.5 : 1)
        }
        .disabled(viewModel.isSendMessageButtonDisabled)
    }
    
    var speakerButtonView: some View{
        Button {
            audioManager.isMute.toggle()
        } label: {
            Image(systemName: audioManager.isMute ? "speaker.slash.circle.fill" : "speaker.wave.2.circle" )
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.myPurpleLight)
                .padding(.leading, 15)
        }
    }
    
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

