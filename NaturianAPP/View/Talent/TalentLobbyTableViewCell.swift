//
//  TalentLobbyTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//

import UIKit

class TalentLobbyTableViewCell: UITableViewCell {
    
    static let identifer = "\(TalentLobbyTableViewCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let subview = UIView()
    let likedBtn = UIButton()
    let postImage = UIImageView()
    let providerName = UILabel()
    let genderIcon = UIImageView()
    let title = UILabel()
    let seedValue = UILabel()
//    let talentDescription = UILabel()
    let locationImage = UIImageView()
    let categoryBTN = UIButton()
    let seedIcon = UIImageView()
    let locationLabel = UILabel()
    let locationIcon = UIImageView()

//    private let titleStack = UIStackView()
    private let seedStack = UIStackView()
    
    private let nameStack = UIStackView()
    private let talentStack = UIStackView()
    private let locationStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        likedBtn.setImage(UIImage(named: "unlike"), for: .normal)
        likedBtn.isSelected = false
        likedBtn.clipsToBounds = false
        likedBtn.layer.shadowOpacity = 0.3
        likedBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        backgroundColor = .clear
//        subview.backgroundColor = .white
        subview.lkCornerRadius = 15
        
        title.font = UIFont(name: Roboto.bold.rawValue, size: 20)
        title.textAlignment = .left
        title.text = "Title"
        title.textColor = .NaturianColor.darkGray
        title.numberOfLines = 1
        
        seedValue.font =  UIFont(name: Roboto.bold.rawValue, size: 20)
        seedValue.textAlignment = .left
        seedValue.text = "70 Seeds"
        seedValue.textColor = .NaturianColor.darkGray

        categoryBTN.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 11)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitleColor(.NaturianColor.darkGray, for: .normal)
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
//        categoryBTN.backgroundColor = .NaturianColor.navigationGray
        categoryBTN.lkCornerRadius = 5
        categoryBTN.lkBorderWidth = 1
        categoryBTN.lkBorderColor = .NaturianColor.darkGray

        providerName.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        providerName.textAlignment = .left
        providerName.text = "David"
        providerName.textColor = .NaturianColor.navigationGray

        genderIcon.image = UIImage(named: "female")
        seedIcon.image = UIImage(named: "seedgray")
        locationIcon.image = UIImage(named: "location")
        
        nameStack.axis = .horizontal
        nameStack.alignment = .center
        nameStack.spacing = 6
        
        seedStack.axis = .horizontal
        seedStack.alignment = .center
        seedStack.spacing = 6
        
        talentStack.axis = .horizontal
        talentStack.alignment = .leading
        talentStack.spacing = 3
        
        locationLabel.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        locationLabel.textColor = .NaturianColor.navigationGray
        locationLabel.text = "Taichung City"
        
        locationStack.axis = .horizontal
        locationStack.alignment = .center
        locationStack.spacing = 6
    }
    
    func layout() {
        
        contentView.addSubview(subview)
        
        subview.addSubview(postImage)
        subview.addSubview(likedBtn)

        subview.addSubview(title)
        subview.addSubview(talentStack)
        subview.addSubview(categoryBTN)
        subview.addSubview(seedStack)
        
        likedBtn.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        talentStack.translatesAutoresizingMaskIntoConstraints = false
        categoryBTN.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        
        talentStack.addArrangedSubview(nameStack)
        talentStack.addArrangedSubview(locationStack)
        
        nameStack.addArrangedSubview(genderIcon)
        nameStack.addArrangedSubview(providerName)
        locationStack.addArrangedSubview(locationIcon)
        locationStack.addArrangedSubview(locationLabel)
        
        seedStack.addArrangedSubview(seedIcon)
        seedStack.addArrangedSubview(seedValue)
        
        NSLayoutConstraint.activate([

            likedBtn.topAnchor.constraint(equalTo: postImage.topAnchor, constant: 16),
            likedBtn.trailingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: -16),
            likedBtn.heightAnchor.constraint(equalToConstant: 32),
            likedBtn.widthAnchor.constraint(equalToConstant: 32),
            
            subview.topAnchor.constraint(equalTo: contentView.topAnchor),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            // postImage
            postImage.topAnchor.constraint(equalTo: subview.topAnchor),
            postImage.leadingAnchor.constraint(equalTo: subview.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: subview.trailingAnchor),
            postImage.widthAnchor.constraint(equalToConstant: subview.frame.width),
            postImage.heightAnchor.constraint(equalTo: postImage.widthAnchor),
            // titleStack
            title.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: postImage.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: postImage.trailingAnchor),
            // talentStack
            talentStack.topAnchor.constraint(equalTo: categoryBTN.bottomAnchor, constant: 6),
            talentStack.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            talentStack.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -24),
            // providerName
            genderIcon.widthAnchor.constraint(equalToConstant: 12),
            genderIcon.heightAnchor.constraint(equalToConstant: 12),
            // locationStack
//            locationStack.leadingAnchor.constraint(equalTo: nameStack.trailingAnchor),
//            locationStack.heightAnchor.constraint(equalToConstant: 12),
            locationIcon.widthAnchor.constraint(equalToConstant: 13),
            locationIcon.heightAnchor.constraint(equalToConstant: 13),
            // seedStack
            seedStack.trailingAnchor.constraint(equalTo: postImage.trailingAnchor),
            seedStack.centerYAnchor.constraint(equalTo: categoryBTN.centerYAnchor),

            seedIcon.widthAnchor.constraint(equalToConstant: 18),
            seedIcon.heightAnchor.constraint(equalToConstant: 18),
            // categoryBTN
            categoryBTN.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            categoryBTN.widthAnchor.constraint(equalToConstant: 84),
            categoryBTN.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
