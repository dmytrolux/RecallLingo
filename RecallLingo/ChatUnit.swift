//
//  ChatUnit.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 15.06.2023.
//

import Foundation

struct ChatUnit: Identifiable, Equatable{
    var id: UUID
    var wordUser: String
    var wordTranslate: String
}
