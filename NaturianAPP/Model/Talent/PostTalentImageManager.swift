//
//  PostTalentImageManager.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/18.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

class TalentImageManaager {
    
    static let shared = TalentManager()
    
    func postTalentImage(image: UIImage) {
        
        let storage = Storage.storage().reference()
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "images/\(UUID().uuidString).jpg"
        
        let fileRef = storage.child(path)
        
        fileRef.putData(imageData!, metadata: nil) { metaData, error in
            if error == nil && metaData != nil {
            }
        }
    }
    
    func retrievePhoto() {
        let db = Firestore.firestore()
        
        db.collection("")
    }
}
