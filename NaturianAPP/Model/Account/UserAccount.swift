//
//  userAccount.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/19.
//

import Foundation

struct UserModel: Codable {
    
    var name: String?
    
    var userID: String?
    
    var seedValue: Int?
    
    var gender: String? 
    
    var userAvatar: String?
    
    var appliedTalent: [String?]
    
    var isAcceptedTalent: [String?]
        
    var blockList: [String]
    
    var likedTalentList: [String]
    
    var likedForumList: [String]
    
    var didGiveSeed: [String]
    
    var email: String?
    
}
