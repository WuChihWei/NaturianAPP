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
    
    var seedValue: Int? = 420
    
    var gender: String? 
    
    var userAvatar: URL?
    
    var appliedTalent: [String?]
    
    var isAccepetedTalent: [String?]
    
}
