//
//  TranslateView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct TranslateView: View {
    @EnvironmentObject var vm: DictViewModel
    var body: some View {
        VStack {
            
            Spacer()
            TextField("Enter text", text: $vm.inputEn)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Button {
                vm.translateText()
            } label: {
                Text("Translate")
            }
            Spacer()
            
            TextField("", text: $vm.outputUk)
                .textFieldStyle(.roundedBorder)
                .accessibilityHint("Translated text")
            
            if vm.isUniqueWord{
                Button("Add to dictionary") {
                    vm.addToDictionary()
                }
            }
            
            
            Spacer()
        }
    }
    
 
}

struct TranslateView_Previews: PreviewProvider {
    static var previews: some View {
        TranslateView()
    }
}


