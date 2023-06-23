//
//  Notifications.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 23.06.2023.
//

import Foundation

struct Notifications{
    static let newMessage = Notification.Name("newMessage")
    static let pressActionKnow = NSNotification.Name("knowNotification")
    static let pressActionCheckMe = NSNotification.Name("checkMeNotification")
    static let pressActionNotKnow = NSNotification.Name("NotKnowNotification")
}
