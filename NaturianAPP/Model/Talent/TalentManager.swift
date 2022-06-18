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
}
