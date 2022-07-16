//
//  ForumManager.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/2.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseStorage

class ForumManager {
    
    static let shared = TalentManager()

    lazy var db = Firestore.firestore()
    
    let forumDatabase = Firestore.firestore().collection("forum")
    let forumReplyDatabase = Firestore.firestore().collection("replies")

    func addPostData(postForum: ForumModel) {
        
        do {
            
            try forumDatabase.document(postForum.postArticleID ?? "").setData(from: postForum)
            
        } catch {
            
            print("can't post talent data")
        }
    }
    
    func updateSeedValue(forumID: String, seedValue: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        forumDatabase.document(forumID).updateData(["getSeedValue": seedValue]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    func updateLikeValue(forumID: String, likeValue: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        forumDatabase.document(forumID).updateData(["getLikedValue": likeValue]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    func addReplyData(replyForum: ReplyModel) {
        
        do {
            
            try forumReplyDatabase.document(replyForum.replyID ?? "").setData(from: replyForum)
            
        } catch {
            
            print("can't post talent data")
        }
    }
    
    func fetchCategoryData(category: String, completion: @escaping (Result<[ForumModel], Error>) -> Void) {
        
        forumDatabase.whereField("category", isEqualTo: category).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var forumModels = [ForumModel]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let forumModel = try document.data(as: ForumModel?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            forumModels.append(forumModel)
                        }
                        print(forumModels)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(forumModels))
            }
        }
    }
    
    func fetchAllData( completion: @escaping (Result<[ForumModel], Error>) -> Void) {
        
        forumDatabase.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var forumModels = [ForumModel]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let forumModel = try document.data(as: ForumModel?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            forumModels.append(forumModel)
                        }
                        print(forumModels)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(forumModels))
            }
        }
    }
    
    func fetchMyLikeData(articleID: String, completion: @escaping (Result<ForumModel, Error>) -> Void) {
        
        db.collection("forum").whereField("postArticleID",
                                          isEqualTo: articleID).addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                
                completion(.failure(error))
                
            } else {
                
                if let doc = querySnapshot?.documents.first {
                    do {
                        print(doc)
                        if let forumModel = try doc.data(as: ForumModel?.self,
                                                        decoder: Firestore.Decoder()) {
                            
                            completion(.success(forumModel))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
            }
        }
    }
    
    func updateAplyIDs(articleID: String, repliedArticle: ForumModel,
                       completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            
            try forumDatabase.document(articleID).setData(from: repliedArticle, merge: true)
            
            completion(.success(()))

        } catch {
            
            print("can't update talent data")
            
        }
    }
    
    func findRepliesData(replyID: String, completion: @escaping (Result<ReplyModel, Error>) -> Void) {
        
        forumReplyDatabase.whereField("replyID", isEqualTo: replyID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                if let doc = querySnapshot?.documents.first {
                    do {
                        print(doc)
                        if let replyModel = try doc.data(as: ReplyModel?.self,
                                                        decoder: Firestore.Decoder()) {
                            
                            completion(.success(replyModel))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
            }
        }
    }
}
