//
//  ViewModel.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import SwiftUI

class WordsModel: ObservableObject {
    @Published var dict: [String: Word] = UserDefaults.standard.dictionary(forKey: "Dict") as? [String: Word] ?? [:] {
        didSet{
            if let encoded = try? JSONEncoder().encode(dict){
                UserDefaults.standard.set(encoded, forKey: "Dict")
            }
        }
    }
    
  
    
}

