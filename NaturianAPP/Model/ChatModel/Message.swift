//
//  Message.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/23.
//

import UIKit
import Firebase
import MessageKit

struct Message {
    
    var id: String
    
    var content: String
    
    var created: Timestamp
    
    var senderID: String
    
    var senderName: String
    
    var isRead: Bool
    
    var dictionary: [String: Any] {
        
        return [
            
            "id": id,
            
            "content": content,
            
            "created": created,
            
            "senderID": senderID,
            
            "senderName": senderName,
            
            "isRead": isRead
        ]
    }
}

extension Message {
    
    init?(dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
              
                let content = dictionary["content"] as? String,
              
                let created = dictionary["created"] as? Timestamp,
              
                let senderID = dictionary["senderID"] as? String,
              
                let senderName = dictionary["senderName"] as? String,
                
                let isRead = dictionary["isRead"] as? Bool
                
        else {return nil}
        
        self.init(id: id,
                  content: content,
                  created: created,
                  senderID: senderID,
                  senderName: senderName,
                  isRead: isRead)
    }
}

extension Message: MessageType {
    
    var sender: SenderType {
        
        return ChatUser(senderId: senderID, displayName: senderName)
        
    }
    
    var messageId: String {
        
        return id
        
    }
    
    var sentDate: Date {
        
        return created.dateValue()
        
    }
    
    var readState: Bool {
        
        return isRead
        
    }
    
    var kind: MessageKind {
        
        return .text(content)
        
    }
}
