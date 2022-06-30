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
        
        db.collection("talent").getDocuments { (querySnapshot, error) in
            
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
    
    
    func fetchMyIDData(userID:String, completion: @escaping (Result<[TalentArticle], Error>) -> Void) {
        
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
                case .success(_):
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
    
    func fetchAcceptedTalent (userID: String, completion: @escaping (Result<[TalentArticle], Error>) -> Void) {

        db.collection("talent").whereField("didAcceptID", arrayContains: userID).getDocuments { (querySnapshot, error) in

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
    
}
