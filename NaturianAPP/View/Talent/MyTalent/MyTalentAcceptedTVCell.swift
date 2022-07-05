//
//  MyTalentDidAcceptTVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import UIKit

class MyTalentAcceptedTVCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        userAvatar.layoutIfNeeded()
    }
    
    static let identifer = "\(MyTalentAcceptedTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let subview = UIView()

    var userAvatar = UIImageView()
//    let messageAmountButton = UIButton()
    let appliedStateBtn = UIButton()
    let chatButton = UIButton()
    let userName = UILabel()
    let userGender = UILabel()
    
    var acceptButton = UIButton()
    var cancelButton = UIButton()
    let buttonStack = UIStackView()
    // Accept MessageAmmount
//    var messageAmmont: Int = 0
    
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
        userName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        userName.textAlignment = .left
        userName.text = "Title"
        
//        userGender.text = "Male"
        userGender.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        userGender.textColor = .NaturianColor.darkGray
    
        appliedStateBtn.setImage(UIImage(named: "waiting_darkgray"), for: .normal)
        appliedStateBtn.tintColor = .NaturianColor.darkGray
        
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = .NaturianColor.treatmentGreen
        acceptButton.lkCornerRadius = 14
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        cancelButton.setTitleColor(.NaturianColor.treatmentGreen, for: .normal)
//        cancelButton.backgroundColor = .NaturianColor.treatmentGreen
        
        chatButton.setImage(UIImage(named: "chat"), for: .normal)
        
        userAvatar.backgroundColor = .gray
        //        userAvatar.layer.cornerRadius = 20
        userAvatar.lkBorderColor = .blue
        userAvatar.contentMode = .scaleToFill
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 0
        
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
    }
    
    func layout() {
        
        contentView.addSubview(subview)

        subview.addSubview(userAvatar)
//        subview.addSubview(messageAmountButton)
        subview.addSubview(talentStackView)
        subview.addSubview(chatButton)
        subview.addSubview(appliedStateBtn)
        subview.addSubview(buttonStack)

        talentStackView.addArrangedSubview(userName)
        talentStackView.addArrangedSubview(userGender)

        buttonStack.addArrangedSubview(acceptButton)
        buttonStack.addArrangedSubview(cancelButton)

        subview.translatesAutoresizingMaskIntoConstraints = false
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        talentStackView.translatesAutoresizingMaskIntoConstraints = false
        appliedStateBtn.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
//        messageAmountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            subview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            subview.heightAnchor.constraint(equalToConstant: 175),
            // postImage
            userAvatar.topAnchor.constraint(equalTo: subview.topAnchor, constant: 20),
            userAvatar.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 18),
            userAvatar.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -20),
            userAvatar.widthAnchor.constraint(equalToConstant: 135),
            userAvatar.heightAnchor.constraint(equalToConstant: 135),
            // appliedStateBtn
            appliedStateBtn.topAnchor.constraint(equalTo: userAvatar.topAnchor),
            appliedStateBtn.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 18),
            appliedStateBtn.widthAnchor.constraint(equalToConstant: 14),
            appliedStateBtn.heightAnchor.constraint(equalToConstant: 14),
            // talentStack
            userName.centerYAnchor.constraint(equalTo: appliedStateBtn.centerYAnchor),
            userName.trailingAnchor.constraint(equalTo: chatButton.leadingAnchor, constant: 2),
            talentStackView.leadingAnchor.constraint(equalTo: appliedStateBtn.trailingAnchor, constant: 6),
            talentStackView.heightAnchor.constraint(equalToConstant: 50),
            // chatButton
            chatButton.centerYAnchor.constraint(equalTo: appliedStateBtn.centerYAnchor),
            chatButton.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -18),
            chatButton.widthAnchor.constraint(equalToConstant: 20),
            chatButton.heightAnchor.constraint(equalToConstant: 20),
            
            buttonStack.leadingAnchor.constraint(equalTo: appliedStateBtn.leadingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 28),
            buttonStack.bottomAnchor.constraint(equalTo: userAvatar.bottomAnchor),
            acceptButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -20),
            cancelButton.trailingAnchor.constraint(equalTo: chatButton.trailingAnchor)
        ])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
