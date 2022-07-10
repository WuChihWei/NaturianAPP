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
    
    
    let database = Firestore.firestore().collection("chats")
    
    func addData(postTalent: TalentArticle) {
        
        do {
            
            try database.document(postTalent.talentPostID ?? "").setData(from: postTalent)
            
        } catch {
            
            print("can't post talent data")
        }
    }
    
    func fetchChatData(userID: String, completion: @escaping (Result<[ChatModel], Error>) -> Void) {
        
        database.whereField("users", arrayContains: userID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var chatModels = [ChatModel]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let chatModel = try document.data(as: ChatModel?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            chatModels.append(chatModel)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(chatModels))
            }
        }
    }
}
