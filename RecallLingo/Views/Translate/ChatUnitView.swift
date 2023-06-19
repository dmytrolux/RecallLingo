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
