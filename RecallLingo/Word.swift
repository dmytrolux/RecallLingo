//
//  Word.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 03.04.2023.
//

import Foundation

struct Word: Codable{
    var original: String
    var translate: String
    var popularity: Int = 1
}
