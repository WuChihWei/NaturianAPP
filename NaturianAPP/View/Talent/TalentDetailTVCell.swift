//
//  TalentDetailTVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/14.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import FirebaseAuth

class TalentDetailTVCell: UITableViewCell {

    static let identifer = "\(TalentDetailTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postPhotoImage = UIImageView()
    let avatarImage = UIImageView()
    let subview = UIView()
//    let closeButton = UIButton()
    
    let titleText = UILabel()
    let categoryBTN = UIButton()
    let moreBtn = UIButton()
    
    let genderIcon = UIImageView()
    let providerName = UILabel()
    private let nameStack = UIStackView()
    
    let descriptionText = UILabel()
    
    let locationLabel = UILabel()
    let locationIcon = UIImageView()
    private let locationStack = UIStackView()
    
    let providerStack = UIStackView()
    let likedBtn = UIButton()
    let contactBtn = UIButton()
    let buttonStack = UIStackView()

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
        
        avatarImage.lkCornerRadius = 38
        avatarImage.lkBorderWidth = 4
        avatarImage.lkBorderColor = .white
        avatarImage.backgroundColor = .NaturianColor.lightGray

        postPhotoImage.backgroundColor = .systemGreen
        postPhotoImage.isUserInteractionEnabled = true
        postPhotoImage.clipsToBounds = true
        postPhotoImage.contentMode = .scaleAspectFill
                
        subview.backgroundColor = .white
        subview.lkCornerRadius = 30
        subview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        categoryBTN.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 12)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitle( "", for: .normal)
        categoryBTN.setTitleColor(.NaturianColor.darkGray, for: .normal)

        categoryBTN.lkCornerRadius = 5
        categoryBTN.lkBorderColor = .NaturianColor.darkGray
        categoryBTN.lkBorderWidth = 1
        
        moreBtn.setImage(UIImage(named: "more"), for: .normal)
        moreBtn.showsMenuAsPrimaryAction = true
        
        titleText.font = UIFont(name: Roboto.bold.rawValue, size: 28)
        titleText.textAlignment = .left
        titleText.text = ""
        titleText.textColor = .NaturianColor.darkGray
        titleText.numberOfLines = 0
        
        descriptionText.font = UIFont(name: Roboto.regular.rawValue, size: 16)
        descriptionText.textAlignment = .justified
        descriptionText.text = ""
        descriptionText.numberOfLines = 0

        locationLabel.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        locationLabel.textColor = .NaturianColor.navigationGray
        locationIcon.image = UIImage(named: "location")
        
        genderIcon.image = UIImage(named: "male")
        providerName.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        providerName.textColor = .NaturianColor.navigationGray
        providerName.text = ""
        
        nameStack.axis = .horizontal
        nameStack.alignment = .center
        nameStack.spacing = 6
        
        locationStack.axis = .horizontal
        locationStack.alignment = .center
        locationStack.spacing = 6
        
        providerStack.axis = .vertical
        providerStack.alignment = .leading
        providerStack.spacing = 2

        contactBtn.setImage(UIImage(named: "chat_green"), for: .normal)
    }
    
    func layout() {
        
        likedBtn.translatesAutoresizingMaskIntoConstraints = false
        contactBtn.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        postPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        titleText.translatesAutoresizingMaskIntoConstraints = false
        categoryBTN.translatesAutoresizingMaskIntoConstraints = false
        providerStack.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        
        postPhotoImage.addSubview(likedBtn)
        contentView.addSubview(postPhotoImage)
        postPhotoImage.addSubview(avatarImage)
        
        contentView.addSubview(subview)
        contentView.addSubview(moreBtn)
        subview.addSubview(contactBtn)

        subview.addSubview(titleText)
        subview.addSubview(categoryBTN)

        subview.addSubview(providerStack)
        subview.addSubview(categoryBTN)
        subview.addSubview(descriptionText)
        subview.addSubview(buttonStack)
        
        providerStack.addArrangedSubview(nameStack)
        providerStack.addArrangedSubview(locationStack)
        
        nameStack.addArrangedSubview(genderIcon)
        nameStack.addArrangedSubview(providerName)
        
        locationStack.addArrangedSubview(locationIcon)
        locationStack.addArrangedSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            
            likedBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            likedBtn.bottomAnchor.constraint(equalTo: subview.topAnchor, constant: -17),
            likedBtn.heightAnchor.constraint(equalToConstant: 40),
            likedBtn.widthAnchor.constraint(equalToConstant: 40),

            postPhotoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            postPhotoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postPhotoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postPhotoImage.heightAnchor.constraint(equalToConstant: 400),
            
            avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            avatarImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            avatarImage.heightAnchor.constraint(equalToConstant: 76),
            avatarImage.widthAnchor.constraint(equalToConstant: 76),
            
            contactBtn.topAnchor.constraint(equalTo: subview.topAnchor, constant: 24),
            contactBtn.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            contactBtn.widthAnchor.constraint(equalToConstant: 34),
            contactBtn.heightAnchor.constraint(equalToConstant: 34),
            
            subview.topAnchor.constraint(equalTo: postPhotoImage.bottomAnchor, constant: -40),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleText.topAnchor.constraint(equalTo: providerStack.bottomAnchor, constant: 10),
            titleText.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            titleText.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            
            categoryBTN.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 10),
            categoryBTN.leadingAnchor.constraint(equalTo: titleText.leadingAnchor),
            categoryBTN.heightAnchor.constraint(equalToConstant: 28),
            categoryBTN.widthAnchor.constraint(equalToConstant: 90),
            
            moreBtn.centerYAnchor.constraint(equalTo: categoryBTN.centerYAnchor),
            moreBtn.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            moreBtn.heightAnchor.constraint(equalToConstant: 20),
            moreBtn.widthAnchor.constraint(equalToConstant: 20),
            
            providerStack.topAnchor.constraint(equalTo: subview.topAnchor, constant: 24),
            providerStack.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            
            genderIcon.widthAnchor.constraint(equalToConstant: 13),
            genderIcon.heightAnchor.constraint(equalToConstant: 13),
            nameStack.heightAnchor.constraint(equalToConstant: 16),
            
            locationStack.heightAnchor.constraint(equalToConstant: 14),
            locationIcon.widthAnchor.constraint(equalToConstant: 14),
            locationIcon.heightAnchor.constraint(equalToConstant: 14),

            descriptionText.leadingAnchor.constraint(equalTo: titleText.leadingAnchor),
            descriptionText.topAnchor.constraint(equalTo: categoryBTN.bottomAnchor, constant: 12),
            descriptionText.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            descriptionText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 24)

        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
