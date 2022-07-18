//
//  TalentModel.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/18.
//

import Foundation

struct TalentArticle: Codable {
    
    let talentPostID: String?
    
    let userID: String?
    
    let userInfo: UserModel?
    
    let category: String?
    
    let location: String?
    
    let title: String?
    
    let content: String?
    
    let images: [String]
    
    let seedValue: Int32?
    
    let createdTime: Int?
    
    var didApplyID: [String]
    
    var didAcceptID: [String]
}
