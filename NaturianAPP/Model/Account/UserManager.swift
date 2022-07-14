//
//  File.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth

class UserManager {
    
    static let shared = UserManager()
    
    lazy var db = Firestore.firestore().collection("users")
    
    func addData(accoutInfo: UserModel) {
        
        do {
            
            try db.document(accoutInfo.userID ?? "").setData(from: accoutInfo)
            
        } catch {
            
            print("can't post talent data")
        }
    }
    
    func fetchData(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        
        db.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var userModels = [UserModel]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let userModel = try document.data(as: UserModel?.self,
                                                             decoder: Firestore.Decoder()) {
                            
                            userModels.append(userModel)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(userModels))
            }
        }
    }
    
    func fetchUserData(userID: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        db.whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                if let doc = querySnapshot?.documents.first {
                    print("exist")
                    do {
                        print(doc)
                        if let userModel = try doc.data(as: UserModel?.self,
                                                        decoder: Firestore.Decoder()) {
                            
                            completion(.success(userModel))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
            }
        }
    }
    
    func listenUserData(userID: String, completion: @escaping (Result<UserModel, Error>) -> Void) {

        db.whereField("userID", isEqualTo: userID).addSnapshotListener { (querySnapshot, error) in

            if let error = error {

                print(LocalizedError.self)
                completion(.failure(error))

            } else {

                if let doc = querySnapshot?.documents.first {
                    print("exist")
                    do {
                        print(doc)
                        if let userModel = try doc.data(as: UserModel?.self,
                                                        decoder: Firestore.Decoder()) {

                            completion(.success(userModel))
                        }

                    } catch {

                        completion(.failure(error))

                    }
                }
            }
        }
    }
    
    func fetchAppliersData(userID: String, talentPostID: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        db.whereField("userID", isEqualTo: userID).whereField("talentPostID", isEqualTo: talentPostID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                if let doc = querySnapshot?.documents.first {
                    do {
                        print(doc)
                        if let userModel = try doc.data(as: UserModel?.self,
                                                        decoder: Firestore.Decoder()) {
                            
                            completion(.success(userModel))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
            }
        }
    }
    
    func fetchAllAppliedUsers(userID: String, appliedUsers: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        db.whereField("userID", isEqualTo: userID).whereField("userID", isEqualTo: appliedUsers).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                if let doc = querySnapshot?.documents.first {
                    do {
                        print(doc)
                        if let userModel = try doc.data(as: UserModel?.self,
                                                        decoder: Firestore.Decoder()) {
                            
                            completion(.success(userModel))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
            }
        }
    }
    
    func searchAppliedState(talentPostID: String,
                            userID: String,
                            completion: @escaping (Result<[UserModel], Error>) -> Void) {
        
        db.whereField("appliedTalent",
                      isEqualTo: talentPostID).whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var userModels = [UserModel]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let userModel = try document.data(as: UserModel?.self,
                                                             decoder: Firestore.Decoder()) {
                            
                            userModels.append(userModel)
                        }
                        print(userModels)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(userModels))
            }
        }
    }
    
    func searchAcceptState(talentPostID: String, userID: String, completion: @escaping (Result<[UserModel], Error>) -> Void) {
        
        db.whereField("isAcceptedTalent",
                      isEqualTo: talentPostID).whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var userModels = [UserModel]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let userModel = try document.data(as: UserModel?.self,
                                                             decoder: Firestore.Decoder()) {
                            
                            userModels.append(userModel)
                        }
                        print(userModels)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(userModels))
            }
        }
    }
    
    func updateAppliedTalent(userModel: UserModel, userID: String) {
        
        do {
            
            try db.document(userID).setData(from: userModel, merge: true)
            
        } catch {
            print("can't update talent data")
        }
    }
    
    func updateLikedTelent(userModel: UserModel, userID: String, talentID: String) {
        
        do {
            
            try db.document(userID).setData(from: userModel, merge: true)
            
        } catch {
            print("can't update talent data")
        }
    }
    
    func updateLikedTelent(uid: String, talentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.document(uid).updateData(["likedTalentList": FieldValue.arrayUnion([talentID])]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    func updateLikedForum(uid: String, forumID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.document(uid).updateData(["likedForumList": FieldValue.arrayUnion([forumID])]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    func addUser(name: String, userID: String, email: String) {
        
        let data: [String: Any] = [
            
            "name": name,
            "userID": userID,
            "seedValue": 420,
            "gender": "",
            "blockList": [""],
            "userAvatar": "",
            "appliedTalent": [""],
            "isAcceptedTalent": [""],
            "email": email
        ]
        
        db.document(userID).setData(data) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
            }
        }
    }
    
    func replaceData(name: String, uid: String, gender: String, userAvatar: String) {
        
        let data: [String: Any] = [
            
            "name": name,
            "gender": gender,
            "userAvatar": userAvatar
        ]
        
        db.document(uid).updateData(data){ error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
            }
        }
    }
    
    func replaceData(userID: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        db.whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                if let doc = querySnapshot?.documents.first {
                    do {
                        print(doc)
                        if let userModel = try doc.data(as: UserModel?.self,
                                                        decoder: Firestore.Decoder()) {
                            
                            completion(.success(userModel))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
            }
        }
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser

        user?.delete { error in
            if error != nil {
                // An error happened.
            } else {
                
                // Account deleted.
            }
        }
        
    }
    
    func updateSeedValue(uid: String, seedValue: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.document(uid).updateData(["seedValue": seedValue]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    func addBlockList(uid: String, blockID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.document(uid).updateData(["blockList": FieldValue.arrayUnion([blockID])]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    func removeBlockList(uid: String, blockID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.document(uid).updateData(["blockList": FieldValue.arrayRemove([blockID])]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    //    func searchBlockListf(userID: String, completion: @escaping (Result<[UserModel], Error>) -> Void) {
    //
    //        db.whereField("blockList",
    //                      isEqualTo: talentPostID).whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
    //
    //            if let error = error {
    //
    //                print(LocalizedError.self)
    //                completion(.failure(error))
    //
    //            } else {
    //
    //                var userModels = [UserModel]()
    //
    //                for document in querySnapshot!.documents {
    //
    //                    do {
    //                        print(document)
    //                        if let userModel = try document.data(as: UserModel?.self,
    //                                                                 decoder: Firestore.Decoder()) {
    //
    //                            userModels.append(userModel)
    //                        }
    //                        print(userModels)
    //
    //                    } catch {
    //
    //                        completion(.failure(error))
    //
    //                    }
    //                }
    //
    //                completion(.success(userModels))
    //            }
    //        }
    //    }
}
