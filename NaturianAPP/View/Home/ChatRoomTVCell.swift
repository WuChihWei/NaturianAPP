//
//  ChatRoomTVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/10.
//

import UIKit

class ChatRoomTVCell: UITableViewCell {

    static let identifer = "\(ChatRoomTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLabel = UILabel()
    let chatIcon = UIImageView()
    let blackView = UIView()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        nameLabel.font = UIFont(name: Roboto.bold.rawValue, size: 18)
        nameLabel.textAlignment = .left
        nameLabel.text = "Title"
        nameLabel.textColor = .NaturianColor.darkGray
        
        chatIcon.image = UIImage(named: "chat")
        
        blackView.backgroundColor = .NaturianColor.navigationGray
    }
    
    func layout() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(chatIcon)
        contentView.addSubview(blackView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        chatIcon.translatesAutoresizingMaskIntoConstraints = false
        
        blackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            chatIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chatIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            chatIcon.widthAnchor.constraint(equalToConstant: 32),
            chatIcon.heightAnchor.constraint(equalToConstant: 32),

            contentView.heightAnchor.constraint(equalToConstant: 98),
            
            blackView.heightAnchor.constraint(equalToConstant: 1),
            blackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
            blackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
