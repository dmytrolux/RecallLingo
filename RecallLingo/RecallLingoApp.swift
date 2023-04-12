//
//  RecallLingoApp.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

@main
struct RecallLingoApp: App {
    @StateObject var viewModel = WordsModel()
    var body: some Scene {
        WindowGroup {
            MainScreen(viewModel: viewModel)
        }
    }
}
