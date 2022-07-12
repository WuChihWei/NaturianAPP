//
//  PostArticleModel.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//

import Foundation


struct ForumModel: Codable {
    
    let postArticleID: String?
    
    var userID: String?
    
    var userInfo: UserModel?
    
    var category: String?
        
    var title: String?
        
    var content: String?
    
    var createdTime: Int?

    let images: [URL]
    
    var getSeedValue: Int?
    
    var getLikedValue: Int?
    
    var replyIDs: [String]
}

struct ReplyModel: Codable {
    
    let replyID: String?
    
    var replyContent: String?
    
    let userID: String?
        
    let createdTime: Date?
    
    let userInfo: UserModel
}
