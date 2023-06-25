//
//  CharacterSets.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 20.06.2023.
//

import Foundation

 struct CharacterSets{
    static let latinSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    static let cyrillicSet = CharacterSet(charactersIn: "АаБбВвГгҐґДдЕеЄєЖжЗзИиІіЇїЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЬьЮюЯяЁёЪъЫыЭэЮюЯя")
    static let numberSet = CharacterSet(charactersIn: "0123456789")
    static let symbolSet = CharacterSet(charactersIn: "!?:;() \n\"''’«»“”„“„”‛’.,-—")
    
    static var latinAndSymbolSet: CharacterSet{
        latinSet.union(numberSet).union(symbolSet)
    }
    
    static var allowedCharacterSet: CharacterSet{
        latinAndSymbolSet.union(cyrillicSet)
    }
     
     static var latinAndCyrillicSet: CharacterSet{
         latinSet.union(cyrillicSet)
     }
}
