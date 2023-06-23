//
//  RememberTextField.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 23.06.2023.
//

import SwiftUI

struct RememberTextField: View {

    @FocusState private var isFocused: Bool
    @Binding var text : String
    var actionSubmit: () -> Void
    
    
    
    var body: some View {
        ZStack{
            if text.isEmpty{
                HStack{
                    Text("Enter translate")
                        .foregroundColor(.myPurpleLight)
                    Spacer()
                }
            }
            TextField("", text: $text)
                .disableAutocorrection(false)
                .textSelection(.enabled)
                .autocapitalization(.sentences)
                .focused($isFocused)
//
                .onSubmit{
                    self.actionSubmit()
                }
                
                
            
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

