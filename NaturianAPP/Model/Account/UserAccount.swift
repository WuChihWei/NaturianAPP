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
    
    var userAvatar: URL?
    
    var appliedTalent: [String?]
    
    var isAccepetedTalent: [String?]
    
    var createdTime: Date?
    
    var blockList: [String]
    
    var email: String?
}
