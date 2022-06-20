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
    
    let database = Firestore.firestore().collection("user")
    
    func addData(accoutInfo: UserModel) {
        
        do {
            
            try database.document(accoutInfo.userID ?? "").setData(from: accoutInfo)
            
        } catch {
            
            print("can't post talent data")
        }
    }
    
    func fetchData(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        
        db.collection("user").getDocuments { (querySnapshot, error) in
            
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
    
    func readData(userID: String) {
        db.collection("uses").whereField("userID", isEqualTo: userID).addSnapshotListener { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let document = querySnapshot.documents.first
            }
            
        }
    }
    
    func fetchApplierData(applierUserID: String, completion: @escaping (Result<[UserModel], Error>) -> Void) {
        
        db.collection("user").document(applierUserID).parent.whereField("userID", isEqualTo: applierUserID).getDocuments { (querySnapshot, error) in
            
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
    
    
}
