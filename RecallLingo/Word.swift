//
//  Word.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import Foundation

struct Word: Identifiable, Codable{
    var id = UUID()
    var word: String
    var translate: String
    var popularity: Int
    
}
