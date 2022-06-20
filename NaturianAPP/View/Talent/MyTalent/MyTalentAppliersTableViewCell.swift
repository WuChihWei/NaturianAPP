//
//  MyTalentAppliersTVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import UIKit

class MyTalentAppliersTableViewCell: UITableViewCell {
    
    static let identifer = "\(MyTalentAppliersTableViewCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userAvatar = UIImageView()
    let category = UILabel()
    let messageAmountButton = UIButton()
    let userName = UILabel()
    var acceptButton = UIButton()
    var cancelButton = UIButton()
    let buttonStack = UIStackView()
    
    // Accept MessageAmmount
    var messageAmmont: Int = 0

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
        
        //        contentView.backgroundColor = .darkGray
        userName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        userName.textAlignment = .left
        userName.text = "Title"
        
        category.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        category.textAlignment = .center
        category.backgroundColor = .green
        category.text = "Category"
        
        messageAmountButton.setTitle("+\(messageAmmont)", for: .normal)
        messageAmountButton.backgroundColor = .lightGray
        messageAmountButton.layer.cornerRadius = 17
        messageAmountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        userAvatar.backgroundColor = .gray
        userAvatar.lkCornerRadius = 50
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 3
    }
    
    func layout() {
        
        contentView.addSubview(userAvatar)
        contentView.addSubview(messageAmountButton)
        contentView.addSubview(talentStackView)
        
        talentStackView.addArrangedSubview(userName)
        talentStackView.addArrangedSubview(category)
        
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        talentStackView.translatesAutoresizingMaskIntoConstraints = false
        messageAmountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // postImage
            userAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            userAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            userAvatar.widthAnchor.constraint(equalToConstant: 100),
            userAvatar.heightAnchor.constraint(equalToConstant: 100),
            userAvatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // talentStack
            talentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            talentStackView.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 18),
            talentStackView.heightAnchor.constraint(equalToConstant: 50),
                        
            // messageAmount
            messageAmountButton.topAnchor.constraint(equalTo: userAvatar.topAnchor),
            messageAmountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            messageAmountButton.widthAnchor.constraint(equalToConstant: 34),
            messageAmountButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
