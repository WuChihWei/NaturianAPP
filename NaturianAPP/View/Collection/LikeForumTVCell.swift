//
//  LikeForumTVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/15.
//

import UIKit

class LikeForumTVCell: UITableViewCell {

    static let identifer = "\(LikeForumTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView()
    let title = UILabel()
    let talentDescription = UILabel()
    let categoryBTN = UIButton()
    var likedBtn = UIButton()
    let addTalentButton = UIButton()
    let subview = UIView()

    private let nameStackView = UIStackView()
    private let talentStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        backgroundColor = .clear
        subview.backgroundColor = .white
        subview.lkCornerRadius = 15
        
        //        contentView.backgroundColor = .darkGray
        title.font = UIFont(name: Roboto.bold.rawValue, size: 15)
        title.textAlignment = .left
        title.text = "Title"
        title.textColor = .NaturianColor.darkGray
        title.numberOfLines = 2
        
        categoryBTN.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
        categoryBTN.lkCornerRadius = 4
        
        talentDescription.font = UIFont(name: Roboto.regular.rawValue, size: 12)
        talentDescription.numberOfLines = 2
        talentDescription.text = "I will teach you how reproduce plants in better ways."
        talentDescription.textAlignment = .left
        
        likedBtn.setImage(UIImage(named: "greenLike"), for: .normal)

        postImage.backgroundColor = .gray
        postImage.contentMode = .scaleAspectFill
        postImage.lkCornerRadius = 10
//        postImage.lkBorderWidth = 1
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 2
    }
    
    func layout() {
        
        contentView.addSubview(subview)
        subview.addSubview(postImage)
        subview.addSubview(talentDescription)
        subview.addSubview(likedBtn)
        subview.addSubview(talentStackView)
        
        subview.addSubview(title)
        talentStackView.addArrangedSubview(categoryBTN)

        title.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        talentDescription.translatesAutoresizingMaskIntoConstraints = false
        talentStackView.translatesAutoresizingMaskIntoConstraints = false
        likedBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            subview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            subview.heightAnchor.constraint(equalToConstant: 175),
            
            title.topAnchor.constraint(equalTo: postImage.topAnchor),
            title.leadingAnchor.constraint(equalTo: talentStackView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -18),
            // postImage
            postImage.topAnchor.constraint(equalTo: subview.topAnchor, constant: 20),
            postImage.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 18),
            postImage.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -20),
            postImage.widthAnchor.constraint(equalToConstant: 135),
            postImage.heightAnchor.constraint(equalToConstant: 135),
   
            // talentStack
            talentStackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            talentStackView.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 14),
            
            categoryBTN.widthAnchor.constraint(equalToConstant: 70),
            categoryBTN.heightAnchor.constraint(equalToConstant: 20),
            
            // talentDescription
            talentDescription.topAnchor.constraint(equalTo: talentStackView.bottomAnchor, constant: 2),
            talentDescription.leadingAnchor.constraint(equalTo: talentStackView.leadingAnchor),
            talentDescription.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            
            // messageAmount
            likedBtn.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            likedBtn.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            likedBtn.widthAnchor.constraint(equalToConstant: 26),
            likedBtn.heightAnchor.constraint(equalToConstant: 26)
        ])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
