//
//  Word.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import Foundation

struct Word: Codable{
    var original: String = ""
    var translate: String = ""
    var popularity: Int = 1
}

struct WordModel{
    var id: String
    var original: String
    var translate: String
    var popularity: Int16
    var date: Date
    
//    init(id: String,
//         original: String,
//         translate: String,
//         popularity: Int16,
//         date: Date) {
//        self.id = id
//        self.original = original
//        self.translate = translate
//        self.popularity = popularity
//        self.date = date
//    }
    
}
