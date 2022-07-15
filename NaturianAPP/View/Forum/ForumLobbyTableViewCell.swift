//
//  ForumLobbyTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit

class ForumLobbyTableViewCell: UITableViewCell {
    
    static let identifer = "\(ForumLobbyTableViewCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView()
    let title = UILabel()
    let categoryBTN = UIButton()
    let articleContent = UILabel()
    
    let subview = UIView()
    //    let secondView = UIView()
    
    let likeBtn = UIButton()
    let likeLB = UILabel()
    let seedBtn = UIButton()
    let seedLB = UILabel()
    
    private let nameStackView = UIStackView()
    private let articleStack = UIStackView()
    private let locationStackView = UIStackView()
    let likestack = UIStackView()
    let seedstack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        //        contentView.backgroundColor = .clear
        subview.backgroundColor = .white
        subview.lkCornerRadius = 15
        
        categoryBTN.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
        categoryBTN.lkCornerRadius = 4
        
        articleContent.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        articleContent.numberOfLines = 3
        articleContent.text = "I will teach you how reproduce plants in better ways."
        articleContent.textAlignment = .justified
        
        postImage.lkCornerRadius = 10
        postImage.lkBorderColor = .lightGray
        postImage.lkBorderWidth = 1
        
        articleStack.axis = .vertical
        articleStack.alignment = .leading
        articleStack.spacing = 3
        
        likeBtn.setImage(UIImage(named: "greenLike"), for: .normal)
        likeLB.text = "321"
        likeLB.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        likeLB.textColor = .NaturianColor.navigationGray
        seedBtn.setImage(UIImage(named: "greenSeed"), for: .normal)
        seedLB.text = "123"
        seedLB.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        seedLB.textColor = .NaturianColor.navigationGray
        
        likestack.axis = .horizontal
        likestack.alignment = .center
        likestack.spacing = 4
        
        seedstack.axis = .horizontal
        seedstack.alignment = .center
        seedstack.spacing = 4
    }
    
    func layout() {
        
        contentView.addSubview(subview)
        
        subview.addSubview(postImage)
        subview.addSubview(articleContent)
        //        contentView.addSubview(genderIcon)
        
        subview.addSubview(articleStack)
        subview.addSubview(nameStackView)
        subview.addSubview(locationStackView)
        
        subview.addSubview(likestack)
        
        likestack.addArrangedSubview(likeBtn)
        likestack.addArrangedSubview(likeLB)
        subview.addSubview(seedstack)
        seedstack.addArrangedSubview(seedBtn)
        seedstack.addArrangedSubview(seedLB)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        articleContent.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        articleStack.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        likestack.translatesAutoresizingMaskIntoConstraints = false
        seedstack.translatesAutoresizingMaskIntoConstraints = false
        
        articleStack.addArrangedSubview(title)
        articleStack.addArrangedSubview(categoryBTN)
        
        NSLayoutConstraint.activate([
            
            // subview
            subview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            subview.heightAnchor.constraint(equalToConstant: 175),
            
            // postImage
            postImage.topAnchor.constraint(equalTo: subview.topAnchor, constant: 20),
            postImage.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 20),
            postImage.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -20),
            postImage.widthAnchor.constraint(equalToConstant: 135),
            postImage.heightAnchor.constraint(equalToConstant: 135),
            
            categoryBTN.widthAnchor.constraint(equalToConstant: 70),
            categoryBTN.heightAnchor.constraint(equalToConstant: 20),
            
            // talentStack
            articleStack.topAnchor.constraint(equalTo: subview.topAnchor, constant: 16),
            articleStack.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 16),
            
            // talentDescription
            title.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            articleContent.topAnchor.constraint(equalTo: articleStack.bottomAnchor, constant: 4),
            articleContent.leadingAnchor.constraint(equalTo: articleStack.leadingAnchor),
            articleContent.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            
            // providerName
            nameStackView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            nameStackView.centerXAnchor.constraint(equalTo: postImage.centerXAnchor),
            nameStackView.heightAnchor.constraint(equalToConstant: 20),
            nameStackView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -16),
            
            likestack.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            likestack.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            likestack.heightAnchor.constraint(equalToConstant: 16),
            likeBtn.widthAnchor.constraint(equalToConstant: 16),
            
            seedstack.leadingAnchor.constraint(equalTo: likestack.trailingAnchor, constant: 8),
            seedstack.bottomAnchor.constraint(equalTo: likestack.bottomAnchor),
            seedstack.heightAnchor.constraint(equalToConstant: 16),
            seedBtn.widthAnchor.constraint(equalToConstant: 16)
            
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
