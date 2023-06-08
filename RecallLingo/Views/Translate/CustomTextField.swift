//
//  CustomTextField.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 30.05.2023.
//

import SwiftUI

struct CustomTextField: View {
    @EnvironmentObject var vm: DictViewModel
    
    var body: some View {
        ZStack{
            if vm.translateRequest.isEmpty{
                HStack{
                    Text("Enter word")
                        .foregroundColor(.myPurpleLight)
                    Spacer()
                }
            }
            TextField("", text: $vm.translateRequest)
                .disableAutocorrection(false)
                .textSelection(.enabled)
                .autocapitalization(.sentences)
                
            
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

//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField()
//    }
//}
