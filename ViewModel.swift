//
//  ViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

class WordsModel: ObservableObject {
    @Published var words = [Word](){
        didSet{
            if let encoded = try? JSONEncoder().encode(words){
                UserDefaults.standard.set(encoded, forKey: "Words")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Words"),
           let decodedItems = try? JSONDecoder().decode([Word].self, from: savedItems) {
            words = decodedItems
        } else {
            words = []
        }
    }
    
}

