//
//  ChatViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 08.06.2023.
//

import SwiftUI


@MainActor
class ChatViewModel: ObservableObject{
    
    @Published var dictVM: DictViewModel
    
    @Published var bufferID = UUID()
    @Published var tapppedID : UUID?
    @Published var isEditMode = false
    @Published var isContainInDict = false //make logica
    @Published var bufferMessageTranslate = ""
    
    @Published var messages: [ChatReplica] = [
        //        ChatReplica(id: UUID(), userWord: "We must all face the choice between what is right and what is easy", translate: "Ми всі повинні обирати між тим, що правильно і тим, що просто "),
        //        ChatReplica(id: UUID(), userWord: "The will to win the desire to succeed, the urge to reach your full potential… these are the keys that will unlock the door to personal excellence. Confucius", translate: "Воля до перемоги, бажання домогтися успіху, прагнення повністю розкрити свої можливості… ось ті ключі, які відкриють двері до особистої досконалості. Конфуцій"),
        //        ChatReplica(id: UUID(), userWord: "Car", translate: "Автомобіль"),
        //        ChatReplica(id: UUID(), userWord: "The truth was that she was a woman before she was a scientist.", translate: "Небо"),
                ChatReplica(id: UUID(), userWord: "The Lord of the Rings", translate: "Володар перснів")
            ]
    
    
    init(dictVM: DictViewModel){
        self.dictVM = dictVM
    }
    
    func sendTranslatedMessage(response: String){
        if !response.isEmpty{
            print("Переклад: \(response)")
            if let index = dictVM.messages.firstIndex(where: {$0.id == bufferID}){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.messages[index].translate = response
//                    vm.clearTextFields()
                }
            } else {
                print("ereor index")
            }
        }
    }
    
//    func clearTextFields(){
//        translateRequest = ""
//        translateResponse = ""
//    }
    
    
    
    
    
    
}
