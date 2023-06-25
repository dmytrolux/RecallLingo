//
//  ChatUnit.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 15.06.2023.
//

import Foundation

struct ChatUnit: Identifiable, Equatable, Hashable{
    var id: UUID
    var wordUser: String
    var wordTranslate: String
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(wordUser)
            hasher.combine(wordTranslate)
        }
}
