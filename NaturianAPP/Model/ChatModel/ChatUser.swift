//
//  ChatUser.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/23.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    
    var senderId: String
    
    var displayName: String
}
