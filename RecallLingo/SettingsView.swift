//
//  SettingsView.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 12.04.2023.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: WordsModel
    var body: some View {
        Button {
            viewModel.dict.removeAll()
        } label: {
            Text("Clear dictionary")
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: WordsModel())
    }
}
