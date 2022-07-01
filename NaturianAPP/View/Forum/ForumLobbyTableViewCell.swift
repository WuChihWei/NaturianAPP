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
    
    let likeBtn = UIButton()
    let likeLB = UILabel()
    let seedBtn = UIButton()
    let seedLB = UILabel()
    
    //    let providerName = UILabel()
    //    let locationImage = UIImageView()
    //    let locationLabel = UILabel()
    //    let seedValue = UILabel()
    //    let genderIcon = UIImageView()
    
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
        
        title.font = UIFont(name: Roboto.bold.rawValue, size: 18)
        title.textAlignment = .left
        title.text = "Title"
        title.textColor = .NaturianColor.darkGray
        
        categoryBTN.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
        categoryBTN.lkCornerRadius = 4
        
        //        seedValue.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        //        seedValue.textAlignment = .left
        //        seedValue.text = "70 Seeds"
        
        //        providerName.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        //        providerName.textAlignment = .center
        //        providerName.text = "David"
        
        //        genderIcon.image = UIImage(named: "female")
        
        title.numberOfLines = 2
//        title.textAlignment = .justified

        articleContent.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        articleContent.numberOfLines = 3
        articleContent.text = "I will teach you how reproduce plants in better ways."
        articleContent.textAlignment = .justified
        
        postImage.lkCornerRadius = 10
        postImage.lkBorderColor = .lightGray
        postImage.lkBorderWidth = 1
  
        //        nameStackView.axis = .horizontal
        //        nameStackView.alignment = .center
        //        nameStackView.spacing = 3
        
                articleStack.axis = .vertical
                articleStack.alignment = .leading
                articleStack.spacing = 3
        
        //        locationStackView.axis = .horizontal
        //        locationStackView.alignment = .center
        //        locationStackView.spacing = 3
        //        locationImage.image = UIImage(named: "location")
        //
        //        locationLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        //        locationLabel.text = "Taichung City"
        
        likeBtn.setImage(UIImage(named: "liked"), for: .normal)
        likeLB.text = "321"
        likeLB.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        likeLB.textColor = .NaturianColor.navigationGray
        seedBtn.setImage(UIImage(named: "seed_green"), for: .normal)
        seedLB.text = "123"
        seedLB.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        seedLB.textColor = .NaturianColor.navigationGray
        
        likestack.axis = .horizontal
        likestack.alignment = .leading
        likestack.spacing = 4
        
        seedstack.axis = .horizontal
        seedstack.alignment = .leading
        seedstack.spacing = 4
    }
    
    func layout() {
        
        contentView.addSubview(postImage)
        contentView.addSubview(articleContent)
//        contentView.addSubview(genderIcon)
        
        contentView.addSubview(articleStack)
        contentView.addSubview(nameStackView)
        contentView.addSubview(locationStackView)
        
        contentView.addSubview(likestack)
        likestack.addArrangedSubview(likeBtn)
        likestack.addArrangedSubview(likeLB)
        contentView.addSubview(seedstack)
        seedstack.addArrangedSubview(seedBtn)
        seedstack.addArrangedSubview(seedLB)
        
        postImage.translatesAutoresizingMaskIntoConstraints = false
        articleContent.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        articleStack.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        likestack.translatesAutoresizingMaskIntoConstraints = false
        seedstack.translatesAutoresizingMaskIntoConstraints = false
//        nameStackView.addArrangedSubview(genderIcon)
//        nameStackView.addArrangedSubview(providerName)
        
        articleStack.addArrangedSubview(title)
//        talentStackView.addArrangedSubview(seedValue)
        articleStack.addArrangedSubview(categoryBTN)

//        locationStackView.addArrangedSubview(locationImage)
//        locationStackView.addArrangedSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            
            // postImage
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            postImage.widthAnchor.constraint(equalToConstant: 135),
            postImage.heightAnchor.constraint(equalToConstant: 135),
            
            categoryBTN.widthAnchor.constraint(equalToConstant: 70),
            categoryBTN.heightAnchor.constraint(equalToConstant: 20),
        
//            genderIcon.widthAnchor.constraint(equalToConstant: 18),
//            genderIcon.heightAnchor.constraint(equalToConstant: 18),
            
            // talentStack
            articleStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            articleStack.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 16),
//            articleStack.heightAnchor.constraint(equalToConstant: 50),
    
            // talentDescription
            title.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            articleContent.topAnchor.constraint(equalTo: articleStack.bottomAnchor, constant: 4),
            articleContent.leadingAnchor.constraint(equalTo: articleStack.leadingAnchor),
            articleContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
//            locationStackView.topAnchor.constraint(equalTo: articleContent.bottomAnchor, constant: 12),
//            locationStackView.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
//            locationStackView.bottomAnchor.constraint(equalTo: nameStackView.bottomAnchor),
//            locationImage.widthAnchor.constraint(equalToConstant: 18),
//            locationImage.heightAnchor.constraint(equalToConstant: 18),
            
            // providerName
            nameStackView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            nameStackView.centerXAnchor.constraint(equalTo: postImage.centerXAnchor),
            nameStackView.heightAnchor.constraint(equalToConstant: 20),
            nameStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
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
