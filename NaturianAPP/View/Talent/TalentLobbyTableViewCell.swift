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
    
    let postImage = UIImageView()
    let providerName = UILabel()
    let genderIcon = UIImageView()
    let title = UILabel()
    let seedValue = UILabel()
    let talentDescription = UILabel()
    let locationImage = UIImageView()
    let categoryBTN = UIButton()
    let seedIcon = UIImageView()
    let locationLabel = UILabel()
    let locationIcon = UIImageView()

    private let titleStack = UIStackView()
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
        
        backgroundColor = .clear
        subview.backgroundColor = .white
        subview.lkCornerRadius = 15
        
        title.font = UIFont(name: Roboto.bold.rawValue, size: 18)
        title.textAlignment = .left
        title.text = "Title"
        title.textColor = .NaturianColor.darkGray
        title.numberOfLines = 1
        
        seedValue.font =  UIFont(name: Roboto.regular.rawValue, size: 12)
        seedValue.textAlignment = .left
        seedValue.text = "70 Seeds"
        seedValue.textColor = .NaturianColor.darkGray

        categoryBTN.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitleColor(.white, for: .normal)
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
        categoryBTN.lkCornerRadius = 4
        
        talentDescription.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        talentDescription.numberOfLines = 2
        talentDescription.text = "I will teach you how reproduce plants in better ways."
        talentDescription.textAlignment = .justified
        talentDescription.textColor = .NaturianColor.darkGray
        
        providerName.font = UIFont(name: Roboto.regular.rawValue, size: 12)
        providerName.textAlignment = .left
        providerName.text = "David"
        providerName.textColor = .NaturianColor.darkGray

        genderIcon.image = UIImage(named: "female")
        seedIcon.image = UIImage(named: "seed_gray")
        locationIcon.image = UIImage(named: "location_gray")
        
        //        postImage.backgroundColor = .gray
        postImage.lkCornerRadius = 10
        postImage.lkBorderWidth = 1
//        postImage.lkBorderColor = .lightGray
        
        titleStack.axis = .vertical
        titleStack.alignment = .leading
        titleStack.spacing = 2
        
        nameStack.axis = .horizontal
        nameStack.alignment = .center
        nameStack.spacing = 6
        
        seedStack.axis = .horizontal
        seedStack.alignment = .center
        seedStack.spacing = 6
        
        talentStack.axis = .vertical
        talentStack.alignment = .leading
        talentStack.spacing = 0
        
        locationLabel.font = UIFont(name: Roboto.regular.rawValue, size: 12)
        locationLabel.textColor = .NaturianColor.darkGray
        locationLabel.text = "Taichung City"
        
        locationStack.axis = .horizontal
        locationStack.alignment = .center
        locationStack.spacing = 6
    }
    
    func layout() {
        
        contentView.addSubview(subview)
        
        subview.addSubview(postImage)
        subview.addSubview(titleStack)
        subview.addSubview(talentStack)
        subview.addSubview(talentDescription)

        subview.addSubview(nameStack)
        subview.addSubview(locationStack)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
//        title.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        talentStack.translatesAutoresizingMaskIntoConstraints = false
        talentDescription.translatesAutoresizingMaskIntoConstraints = false
        locationStack.translatesAutoresizingMaskIntoConstraints = false
        
        titleStack.addArrangedSubview(title)
        titleStack.addArrangedSubview(categoryBTN)
        
        nameStack.addArrangedSubview(genderIcon)
        nameStack.addArrangedSubview(providerName)
        
        seedStack.addArrangedSubview(seedIcon)
        seedStack.addArrangedSubview(seedValue)
        
        talentStack.addArrangedSubview(seedStack)
        talentStack.addArrangedSubview(nameStack)
        
        locationStack.addArrangedSubview(locationIcon)
        locationStack.addArrangedSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            
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
            // titleStack
            titleStack.topAnchor.constraint(equalTo: postImage.topAnchor),
            titleStack.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 18),
            titleStack.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            categoryBTN.widthAnchor.constraint(equalToConstant: 70),
            categoryBTN.heightAnchor.constraint(equalToConstant: 18),
            // talentStack
            talentStack.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 2),
            talentStack.leadingAnchor.constraint(equalTo: titleStack.leadingAnchor),
            talentStack.heightAnchor.constraint(equalToConstant: 28),
            talentStack.trailingAnchor.constraint(equalTo: titleStack.trailingAnchor),
            // providerName
            nameStack.heightAnchor.constraint(equalToConstant: 14),
            seedStack.heightAnchor.constraint(equalToConstant: 14),
            seedIcon.widthAnchor.constraint(equalToConstant: 12),
            seedIcon.heightAnchor.constraint(equalToConstant: 12),
            genderIcon.widthAnchor.constraint(equalToConstant: 12),
            genderIcon.heightAnchor.constraint(equalToConstant: 12),
            
            // talentDescription
            talentDescription.topAnchor.constraint(equalTo: nameStack.bottomAnchor),
            talentDescription.leadingAnchor.constraint(equalTo: titleStack.leadingAnchor),
            talentDescription.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            talentDescription.heightAnchor.constraint(equalToConstant: 36),
//            locationStack.topAnchor.constraint(equalTo: talentDescription.bottomAnchor, constant: 12),
            locationStack.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            locationStack.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            locationStack.heightAnchor.constraint(equalToConstant: 12),
            locationIcon.widthAnchor.constraint(equalToConstant: 10),
            locationIcon.heightAnchor.constraint(equalToConstant: 10)
            
        ])
    }
}
