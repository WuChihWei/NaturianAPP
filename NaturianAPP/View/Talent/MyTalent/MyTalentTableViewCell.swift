//
//  MyTalentTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit

class MyTalentTableViewCell: UITableViewCell {
    
    static let identifer = "\(MyTalentTableViewCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView()
    let title = UILabel()
    let talentDescription = UILabel()
    let categoryBTN = UIButton()
    let messageAmountButton = UIButton()
    let addTalentButton = UIButton()
    let subview = UIView()
    let seedValue = UILabel()
    let seedIcon = UIImageView()
    private let seedStack = UIStackView()

    // Accept MessageAmmount
    var messageAmmont: Int = 6

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
        title.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        title.textAlignment = .left
        title.text = "Title"
        title.textColor = .NaturianColor.darkGray
        title.numberOfLines = 2
        
        seedValue.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        seedValue.textAlignment = .left
        seedValue.text = "70 Seeds"
        seedIcon.image = UIImage(named: "seed_gray")

        categoryBTN.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
        categoryBTN.lkCornerRadius = 4
        
        talentDescription.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        talentDescription.numberOfLines = 2
        talentDescription.text = "I will teach you how reproduce plants in better ways."
        talentDescription.textAlignment = .justified
        
        messageAmountButton.setTitle("+\(messageAmmont)", for: .normal)
        messageAmountButton.backgroundColor = .lightGray
        messageAmountButton.lkCornerRadius = 13
        messageAmountButton.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 12)

        postImage.backgroundColor = .gray
        postImage.contentMode = .scaleAspectFill
        postImage.lkCornerRadius = 10
//        postImage.lkBorderWidth = 1
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 2
        
        seedStack.axis = .horizontal
        seedStack.alignment = .center
        seedStack.spacing = 6
    }
    
    func layout() {
        
        contentView.addSubview(subview)
        subview.addSubview(postImage)
        subview.addSubview(talentDescription)
        subview.addSubview(messageAmountButton)
        subview.addSubview(talentStackView)
        
        subview.addSubview(title)
        talentStackView.addArrangedSubview(categoryBTN)
        talentStackView.addArrangedSubview(seedStack)
        
        seedStack.addArrangedSubview(seedIcon)
        seedStack.addArrangedSubview(seedValue)

        title.translatesAutoresizingMaskIntoConstraints = false
        seedStack.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        talentDescription.translatesAutoresizingMaskIntoConstraints = false
        talentStackView.translatesAutoresizingMaskIntoConstraints = false
        messageAmountButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            seedIcon.widthAnchor.constraint(equalToConstant: 12),
            seedIcon.heightAnchor.constraint(equalToConstant: 12),
            
            categoryBTN.widthAnchor.constraint(equalToConstant: 70),
            categoryBTN.heightAnchor.constraint(equalToConstant: 20),
            
            // talentDescription
            talentDescription.topAnchor.constraint(equalTo: talentStackView.bottomAnchor, constant: 3),
            talentDescription.leadingAnchor.constraint(equalTo: talentStackView.leadingAnchor),
            talentDescription.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            
            // messageAmount
            messageAmountButton.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            messageAmountButton.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            messageAmountButton.widthAnchor.constraint(equalToConstant: 26),
            messageAmountButton.heightAnchor.constraint(equalToConstant: 26)
        ])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
