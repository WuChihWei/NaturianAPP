//
//  ForumDetailPostTBCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/1.
//

import UIKit

class ForumDetailPostTBCell: UITableViewCell {
    
    static let identifer = "\(ForumDetailPostTBCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView()
    let avatarImage = UIImageView()
    let subview = UIView()
    
    let title = UILabel()
    let categoryBTN = UIButton()
    
    let articleContent = UILabel()
    let authorLB = UILabel()
    
    let dottedLine = UIImageView()
    let solidLine = UIView()
    let likeBtn = UIButton()
    let seedBtn = UIButton()
    let buttonStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func ovveride() {
        
    }
    
    func styleObject() {
        
        postImage.image = UIImage(named: "weave")
        postImage.contentMode = .scaleAspectFill

        avatarImage.image = UIImage(named: "")
        avatarImage.lkBorderColor = .white
        avatarImage.lkCornerRadius = 42
        avatarImage.lkBorderWidth = 4
        avatarImage.backgroundColor = .NaturianColor.lightGray
        
        subview.backgroundColor = .white
        subview.lkCornerRadius = 30
        title.font = UIFont(name: Roboto.bold.rawValue, size: 28)
        title.textAlignment = .left
        title.text = "This is title"
        title.textColor = .NaturianColor.darkGray
        
        categoryBTN.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.setTitleColor(.NaturianColor.darkGray, for: .normal)
//        categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
        categoryBTN.lkCornerRadius = 5
        categoryBTN.lkBorderWidth = 1
        categoryBTN.lkBorderColor = .NaturianColor.darkGray

        title.numberOfLines = 0
        
        articleContent.font = UIFont(name: Roboto.regular.rawValue, size: 16)
        articleContent.textColor = .NaturianColor.darkGray
        articleContent.numberOfLines = 0
        articleContent.text = ""
        articleContent.textAlignment = .justified
        
        authorLB.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        authorLB.textColor = .NaturianColor.darkGray
        authorLB.text = "Writen By : Linda"
        
//        likeBtn.setImage(UIImage(named: "grayLike"), for: .normal)
        
        dottedLine.image = UIImage(named: "dottedLine")
        solidLine.backgroundColor = .black
        
//        seedBtn.setImage(UIImage(named: "graySeed"), for: .normal)
        
        buttonStack.axis = .horizontal
        buttonStack.alignment = .bottom
        buttonStack.spacing = 20
    }
    
    func layout() {
        
        contentView.addSubview(postImage)
        postImage.addSubview(avatarImage)
        contentView.addSubview(subview)

        subview.addSubview(title)
        subview.addSubview(categoryBTN)
        subview.addSubview(articleContent)
        subview.addSubview(authorLB)
        subview.addSubview(dottedLine)
        subview.addSubview(buttonStack)
        subview.addSubview(solidLine)
        
        buttonStack.addArrangedSubview(likeBtn)
        buttonStack.addArrangedSubview(seedBtn)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        title.translatesAutoresizingMaskIntoConstraints = false
        //        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        categoryBTN.translatesAutoresizingMaskIntoConstraints = false
        articleContent.translatesAutoresizingMaskIntoConstraints = false
        authorLB.translatesAutoresizingMaskIntoConstraints = false
        dottedLine.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        solidLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            postImage.heightAnchor.constraint(equalToConstant: 400),
                        
            avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            avatarImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            avatarImage.heightAnchor.constraint(equalToConstant: 84),
            avatarImage.widthAnchor.constraint(equalToConstant: 84),
            
            subview.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: -40),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            title.topAnchor.constraint(equalTo: subview.topAnchor, constant: 24),
            title.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            
            categoryBTN.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            categoryBTN.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            categoryBTN.widthAnchor.constraint(equalToConstant: 90),
            categoryBTN.heightAnchor.constraint(equalToConstant: 28),
            
            articleContent.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            articleContent.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            articleContent.topAnchor.constraint(equalTo: categoryBTN.bottomAnchor, constant: 10),
            
            authorLB.topAnchor.constraint(equalTo: articleContent.bottomAnchor, constant: 60),
            authorLB.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            authorLB.heightAnchor.constraint(equalToConstant: 14),
            
            dottedLine.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            dottedLine.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            dottedLine.heightAnchor.constraint(equalToConstant: 2),
            dottedLine.topAnchor.constraint(equalTo: authorLB.bottomAnchor, constant: 8),
            
            buttonStack.leadingAnchor.constraint(equalTo: dottedLine.leadingAnchor),
            buttonStack.topAnchor.constraint(equalTo: dottedLine.bottomAnchor, constant: 9),
            buttonStack.heightAnchor.constraint(equalToConstant: 28),
            likeBtn.widthAnchor.constraint(equalToConstant: 28),
            seedBtn.widthAnchor.constraint(equalToConstant: 28),
            
            solidLine.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 9),
            solidLine.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            solidLine.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            solidLine.heightAnchor.constraint(equalToConstant: 1),
            solidLine.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0)
        ])
    }    
}
