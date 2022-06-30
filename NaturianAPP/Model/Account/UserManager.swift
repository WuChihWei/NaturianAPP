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

class UserManager {
    
    static let shared = UserManager()
    
    lazy var db = Firestore.firestore()
    
    let database = Firestore.firestore().collection("users")
    
    func addData(accoutInfo: UserModel) {
        
        do {
            
            try database.document(accoutInfo.userID ?? "").setData(from: accoutInfo)
            
        } catch {
            
            print("can't post talent data")
        }
    }
    
    func fetchData(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        
        db.collection("users").getDocuments { (querySnapshot, error) in
            
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
        
        db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            
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
        
        db.collection("users").whereField("userID", isEqualTo: userID).whereField("userID", isEqualTo: appliedUsers).getDocuments { (querySnapshot, error) in
            
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
    
    func searchAppliedState(talentPostID: String, userID: String, completion: @escaping (Result<[UserModel], Error>) -> Void) {
        
        db.collection("users").whereField("appliedTalent", isEqualTo: talentPostID).whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            
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
        
        db.collection("users").whereField("isAcceptedTalent", isEqualTo: talentPostID).whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            
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
    
    func updateData(userModel: UserModel) {
        
        do {
            
            try database.document("123").setData(from: userModel, merge: true)
            
        } catch {
            
            print("can't update talent data")
            
        }
    }
    
    func updateAppliedTalent(userModel: UserModel) {
        
        do {
            
            try database.document("1").setData(from: userModel, merge: true)
            
        } catch {
            
            print("can't update talent data")
            
        }
        
    }
    
    func readAccountData(userID: String) {
        
        db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    print(document.data())
                }
            }
        }
    }
}
