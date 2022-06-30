//
//  ProfileManager.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/29.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseStorage

class UserFirebaseManager {
    
    static let shared = UserFirebaseManager()
    lazy var db = Firestore.firestore().collection("users")
    var currentUser: UserModel?
    var userData: UserModel?
    
    func addUser(name: String, uid: String, email: String) {
        
        let timeInterval = Date()
        let data: [String: Any] = [
            
            "name": name,
            "userID": uid,
            "seedValue": 420,
            "gender": "",
            "userAvatar": "",
            "appliedTalent": [""],
            "isAccepetedTalent": [""],
            "email": email,
            "createdTime": timeInterval
        ]
        
        db.document(uid).setData(data) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
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
    
    func replaceData(name: String, uid: String, email: String, gender: String, userAvatar: String) {
        
        let timeInterval = Date()
        let data: [String: Any] = [
            
            "name": name,
            "userID": uid,
            "seedValue": 420,
            "gender": gender,
            "userAvatar": userAvatar,
            "appliedTalent": [""],
            "isAccepetedTalent": [""],
            "email": email,
            "createdTime": timeInterval
        ]
        
        db.document(uid).setData(data) { error in
            
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
    
    func updateSeedValue(uid: String, seedValue: Int) {
        
//        let data: [String: Any] = [
//
//            "seedValue": seedValue
//        ]
        
        db.document(uid).updateData(["seedValue": seedValue]){ error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
            }
        }
    }
}
