//
//  CustomTextField.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 30.05.2023.
//

import Combine
import SwiftUI


struct TranslateTextField: View {
    
    @ObservedObject var vm: TranslateViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack{
            if vm.wordRequest.isEmpty{
                HStack{
                    Text("tEnterEnglishWord")
                        .foregroundColor(.myPurpleLight)
                    Spacer()
                }
            }
            TextField("", text: $vm.wordRequest)
                .disableAutocorrection(false)
                .textSelection(.enabled)
                .autocapitalization(.sentences)
                .focused($isFocused)
                .onReceive(vm.$isTextFieldFocused) { focused in
                    isFocused = focused
//                    print("focused: \(focused)")
                }
                .onChange(of: isFocused, perform: { newValue in
                    vm.isHidenTitle = newValue
                
                })
                .onSubmit{
                        if vm.isEditMode{
                            if !vm.isEditDoneViewDisabled{
                                vm.finishEditingTranslationThisWord()
                            }
                        } else {
                            if !vm.isSendMessageButtonDisabled{
                                vm.sendMessageForTranslation()
                            }
                        }
                    
                }
                .onReceive(Just(vm.wordRequest)) { newValue in
                    vm.handleReceivedText(newValue)
                }
                
            
        }
        .frame(height: 25)
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
        .gesture(bottomDrag)
    }
    
    var bottomDrag: some Gesture{
        DragGesture()
            .onChanged({ value in
                if value.translation.height > 100{
                    hideKeyboard()
                }
            })
    }
    
    private func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    
}


