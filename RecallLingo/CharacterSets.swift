//
//  CharacterSets.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 20.06.2023.
//

import Foundation

struct CharacterSets{
    static let englishSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    static let numberSet = CharacterSet(charactersIn: "0123456789")
    static let symbolSet = CharacterSet(charactersIn: "!?:;() \n\"'’.,-—")
    
    static var allowedCharacterSet: CharacterSet{
        englishSet.union(numberSet).union(symbolSet)
    }
}
