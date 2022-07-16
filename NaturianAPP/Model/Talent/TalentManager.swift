//
//  TalentManager.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/18.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseStorage

class TalentManager {
    
    static let shared = TalentManager()
    
    lazy var db = Firestore.firestore()
    
    let database = Firestore.firestore().collection("talent")
    
    func addData(postTalent: TalentArticle) {
        
        do {
            
            try database.document(postTalent.talentPostID ?? "").setData(from: postTalent)
            
        } catch {
            
            print("can't post talent data")
        }
    }
    
    func fetchData(completion: @escaping (Result<[TalentArticle], Error>) -> Void) {
        
        db.collection("talent").addSnapshotListener{ (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var talentArticles = [TalentArticle]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let talentArticle = try document.data(as: TalentArticle?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            talentArticles.append(talentArticle)
                        }
                        print(talentArticles)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(talentArticles))
            }
        }
    }
    
    func fetchBlockListData(blockList: [String], completion: @escaping (Result<[TalentArticle], Error>) -> Void) {
        
        database.whereField("userID", notIn: blockList) .getDocuments { (querySnapshot, error) in
            
            print(blockList)
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var talentArticles = [TalentArticle]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let talentArticle = try document.data(as: TalentArticle?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            talentArticles.append(talentArticle)
                        }
                        print(talentArticles)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(talentArticles))
            }
        }
    }
    
    func fetch1BlockListData(blockList: [String], completion: @escaping (Result<[TalentArticle], Error>) -> Void) {
        
        database.whereField("userID", isNotEqualTo: blockList.first!) .getDocuments { (querySnapshot, error) in
            
            print(blockList.first!)
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var talentArticles = [TalentArticle]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let talentArticle = try document.data(as: TalentArticle?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            talentArticles.append(talentArticle)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(talentArticles))
            }
        }
    }
    
    func fetchMyIDData(userID: String, completion: @escaping (Result<[TalentArticle], Error>) -> Void) {
        
        db.collection("talent").whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                
                completion(.failure(error))
                
            } else {
                
                var talentArticles = [TalentArticle]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let talentArticle = try document.data(as: TalentArticle?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            talentArticles.append(talentArticle)
                        }
                        print(talentArticles)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(talentArticles))
            }
        }
    }
    
    func fetchMyLikeData(talentID: String, completion: @escaping (Result<TalentArticle, Error>) -> Void) {
        
        db.collection("talent").whereField("talentPostID",
                                           isEqualTo: talentID).addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                
                completion(.failure(error))
                
            } else {
                if let doc = querySnapshot?.documents.first {
                    do {
                        print(doc)
                        if let talentModel = try doc.data(as: TalentArticle?.self,
                                                        decoder: Firestore.Decoder()) {
                            
                            completion(.success(talentModel))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateData(applyTalent: TalentArticle) {
        
        do {
            
            try database.document(applyTalent.talentPostID ?? "").setData(from: applyTalent, merge: true)
            
        } catch {
            
            print("can't update talent data")
            
        }
        
    }
    
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.9) {
            
            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success:
                    fileReference.downloadURL(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchAppliedTalent (userID: String, completion: @escaping (Result<[TalentArticle], Error>) -> Void) {
        
        db.collection("talent").whereField("didApplyID", arrayContains: userID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var talentArticles = [TalentArticle]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let talentArticle = try document.data(as: TalentArticle?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            talentArticles.append(talentArticle)
                        }
                        print(talentArticles)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(talentArticles))
            }
        }
    }
    
    func fetchMyAppliedTalent (userID: String,
                               talentPostID: String,
                               completion: @escaping (Result<TalentArticle, Error>) -> Void) {
        
        db.collection("talent").whereField("userID",
                                           isEqualTo: userID).whereField("talentPostID",
                                                                         isEqualTo: talentPostID).addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                if let doc = querySnapshot?.documents.first {
                    do {
                        print(doc)
                        if let talentArticle = try doc.data(as: TalentArticle?.self,
                                                        decoder: Firestore.Decoder()) {
                            
                            completion(.success(talentArticle))
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
            }
        }
    }
    
    func fetchAcceptedTalent (userID: String, completion: @escaping (Result<[TalentArticle], Error>) -> Void) {
        
        db.collection("talent").whereField("didAcceptID",
                                           arrayContains: userID).getDocuments { (querySnapshot, error) in
            
            if let error = error {
                
                print(LocalizedError.self)
                completion(.failure(error))
                
            } else {
                
                var talentArticles = [TalentArticle]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        print(document)
                        if let talentArticle = try document.data(as: TalentArticle?.self,
                                                                 decoder: Firestore.Decoder()) {
                            
                            talentArticles.append(talentArticle)
                        }
                        print(talentArticles)
                        
                    } catch {
                        
                        completion(.failure(error))
                        
                    }
                }
                
                completion(.success(talentArticles))
            }
        }
    }
    
    func fetchFilterTalent (category: [String],
                            seedValue: Int,
                            gender: String,
                            location: String,
                            completion: @escaping (Result<[TalentArticle], Error>) -> Void) {
        
        db.collection("talent").whereField("category", in: category)
            .whereField("seedValue", isLessThan: seedValue).whereField("userInfo.gender", isEqualTo: gender)
            .whereField("location", isEqualTo: location)
            .getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    
                    print(LocalizedError.self)
                    completion(.failure(error))
                    
                } else {
                    
                    var talentArticles = [TalentArticle]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            print(document)
                            if let talentArticle = try document.data(as: TalentArticle?.self,
                                                                     decoder: Firestore.Decoder()) {
                                
                                talentArticles.append(talentArticle)
                            }
                            print(talentArticles)
                            
                        } catch {
                            
                            completion(.failure(error))
                            
                        }
                    }
                    
                    completion(.success(talentArticles))
                }
            }
    }
    
    func removeApplyState(applyTalentID: String,
                          applierID: String,
                          completion: @escaping (Result<Void, Error>) -> Void) {
        
        database.document(applyTalentID ).updateData([
            "didApplyID": FieldValue.arrayRemove([applierID])
        ]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    func cancelAcceptState(applyTalentID: String,
                           applierID: String,
                           completion: @escaping (Result<Void, Error>) -> Void) {
        
        database.document(applyTalentID ).updateData([
            "didAcceptID": FieldValue.arrayRemove([applierID])
        ]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
    
    func updateAcceptState(applyTalentID: String,
                           applierID: String,
                           completion: @escaping (Result<Void, Error>) -> Void) {
        
        database.document(applyTalentID ).updateData([
            "didAcceptID": FieldValue.arrayUnion([applierID])
        ]) { error in
            
            if let error = error {
                print(error)
            } else {
                print("Document Update!")
                completion(.success(()))
            }
        }
    }
}
