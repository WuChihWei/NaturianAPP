//
//  Chat.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/23.
//

import Foundation

struct Chat {
    
    var users: [String]
    
    var chatTalentID: String
    
    var dictionary: [String: Any] {
        
        return [
            
            "users": users,
            
            "chatTalentID": chatTalentID
            
        ]
    }
}

extension Chat {
    
    init?(dictionary: [String: Any]) {
        
        guard let chatUsers = dictionary["users"] as? [String] else {
            return nil
        }
        
        guard let chatTalentID = dictionary["chatTalentID"] as? String else {
            return nil
        }

        self.init(users: chatUsers, chatTalentID: chatTalentID)
    }
}
