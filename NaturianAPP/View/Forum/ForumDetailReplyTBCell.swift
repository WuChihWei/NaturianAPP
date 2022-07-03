//
//  ForumDetailReplyTBCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/1.
//

import UIKit

class ForumDetailReplyTBCell: UITableViewCell {

    static let identifer = "\(ForumDetailReplyTBCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var replierName = UILabel()
    var replierAvatar = UIImageView()
    var replyContent = UILabel()
    var createdTimeLB = UILabel()
    let solidLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        replierAvatar.backgroundColor = .NaturianColor.lightGray
        replierAvatar.lkBorderColor = .NaturianColor.darkGray
        replierAvatar.lkBorderWidth = 1
        replierAvatar.lkCornerRadius = 23
        
        replierName.text = "David"
        replierName.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        replierName.textColor = .NaturianColor.darkGray
  
        replyContent.font = UIFont(name: Roboto.regular.rawValue, size: 16)
        replyContent.textColor = .NaturianColor.darkGray
        replyContent.numberOfLines = 0
        replyContent.text = "Describe your talent herePlease describe your talent herePlease describe your talent herePlease describe."
        replyContent.textAlignment = .justified
        
        createdTimeLB.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        createdTimeLB.textColor = .NaturianColor.navigationGray
        createdTimeLB.text = "Created on 10/09/2024"
        createdTimeLB.textAlignment = .right
        
        solidLine.backgroundColor = .black

    }
    
    func layout() {
        
        contentView.addSubview(replierName)
        contentView.addSubview(replierAvatar)
        contentView.addSubview(replyContent)
        contentView.addSubview(createdTimeLB)
        contentView.addSubview(solidLine)
        
        replierName.translatesAutoresizingMaskIntoConstraints = false
        replierAvatar.translatesAutoresizingMaskIntoConstraints = false
        replyContent.translatesAutoresizingMaskIntoConstraints = false
        createdTimeLB.translatesAutoresizingMaskIntoConstraints = false
        solidLine.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            replierAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            replierAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            replierAvatar.widthAnchor.constraint(equalToConstant: 46),
            replierAvatar.heightAnchor.constraint(equalToConstant: 46),
     
            replyContent.leadingAnchor.constraint(equalTo: replierAvatar.leadingAnchor),
            replyContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            replyContent.topAnchor.constraint(equalTo: replierAvatar.bottomAnchor, constant: 24),
            
            replierName.centerYAnchor.constraint(equalTo: replierAvatar.centerYAnchor),
            replierName.leadingAnchor.constraint(equalTo: replierAvatar.trailingAnchor, constant: 20),
            replierName.heightAnchor.constraint(equalToConstant: 14),
            
            solidLine.leadingAnchor.constraint(equalTo: replyContent.leadingAnchor),
            solidLine.trailingAnchor.constraint(equalTo: replyContent.trailingAnchor),
            solidLine.heightAnchor.constraint(equalToConstant: 1),
            solidLine.topAnchor.constraint(equalTo: replyContent.bottomAnchor, constant: 24),
            solidLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            createdTimeLB.trailingAnchor.constraint(equalTo: replyContent.trailingAnchor),
            createdTimeLB.bottomAnchor.constraint(equalTo: replierAvatar.bottomAnchor),
            createdTimeLB.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
