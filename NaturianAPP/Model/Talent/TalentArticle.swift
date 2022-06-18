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
    
    let category: String?
    
    let location: String?
    
    let title: String?
    
    let content: String?
    
    let images: [String: String]
    
    let seedValue: String?
    
    let createdTime: Int?
    
    let appliers: String?
}
//
//struct applierID: Codable {
//
//    let userID: String
//}
