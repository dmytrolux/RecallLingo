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
                    Text("rEnterTranslate".localized())
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

    }

}
