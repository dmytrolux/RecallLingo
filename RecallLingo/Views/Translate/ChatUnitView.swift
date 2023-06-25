//
//  ChatUnitView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 15.06.2023.
//

import SwiftUI

struct ChatUnitView: View{
    @ObservedObject var viewModel: TranslateViewModel
    
    var chatUnit: ChatUnit
    
    var body: some View{
        VStack{
            if !chatUnit.wordTranslate.isEmpty || viewModel.isEditMode{
                MessageTranslateView(viewModel: viewModel,
                                 chatUnit: chatUnit)
            }
            
            MessageUserView(viewModel: viewModel, message: chatUnit)
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
    }
}

struct Flag: View{
    let emoji: String
    var body: some View{
        ZStack{
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 40, height: 40)
            Text(emoji)
                .font(.system(size: 30))
        }
    }
}

struct Flag2: View{
    let emoji: String
    var body: some View{
        HStack{
            VStack{
                Text(emoji)
                    .font(.system(size: 30))
                Spacer()
            }
            Spacer()
        }
        .offset(x: -10, y: -15)
    }
}
