//
//  ChatManager.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/26.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseStorage

class ChatManager {
    
    static let shared = ChatManager()
    
    lazy var db = Firestore.firestore()
    
    let database = Firestore.firestore().collection("chats")
    
    func addData(postTalent: TalentArticle) {
        
        do {
            
            try database.document(postTalent.talentPostID ?? "").setData(from: postTalent)
            
        } catch {
            
            print("can't post talent data")
        }
    }
    
}
