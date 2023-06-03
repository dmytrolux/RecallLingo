//
//  MessageUser.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 30.05.2023.
//

import SwiftUI

struct MessageUser: View {
    var message: ChatReplica
    
    var body: some View {
        HStack{
            Text(message.userWord)
                .foregroundColor(.myYellow)
                .padding(15)
                .background(Color.myPurple)
                .cornerRadius(15)
                .frame(minWidth: UIScreen.main.bounds.width*(1/4),
                       maxWidth: UIScreen.main.bounds.width*(3/4),
                       alignment: .leading)
            Spacer()
        }
        .rotationEffect(.degrees(180))
        .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

struct MessageUser_Previews: PreviewProvider {
    static var previews: some View {
        MessageUser(message: ChatReplica(id: UUID(),
                                         userWord: "Dog",
                                         translate: "Собака"))
    }
}
