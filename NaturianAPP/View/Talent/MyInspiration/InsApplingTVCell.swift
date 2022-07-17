//
//  OtherTalentTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import UIKit

class InsApplingTVCell: UITableViewCell {
    
    static let identifer = "\(InsApplingTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView()
//    let categoryBTN = UIButton()
    let title = UILabel()
    let appliedStateBtn = UIButton()
//    let talentDescription = UILabel()
    var finishedBtn = UIButton()
    let seedValue = UILabel()
    let seedIcon = UIImageView()
    let providerName = UILabel()
    let chatButton = UIButton()
    
    let subview = UIView()
    private let seedStack = UIStackView()

//    let contactButtons = [UIButton]()
    
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
        
        backgroundColor = .clear
        subview.backgroundColor = .white
        subview.lkCornerRadius = 15
        
        //        contentView.backgroundColor = .darkGray
        title.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        title.textAlignment = .left
        title.text = "Title"
        title.textColor = .NaturianColor.darkGray
        title.numberOfLines = 2
        
        seedValue.font = UIFont(name: Roboto.regular.rawValue, size: 12)
        seedValue.textAlignment = .left
        seedValue.text = "70"
        seedValue.textColor = .NaturianColor.navigationGray
        seedIcon.image = UIImage(named: "graySeed")
        
        providerName.font = UIFont(name: Roboto.regular.rawValue, size: 12)
        providerName.textAlignment = .left
        providerName.text = "David"
        providerName.textColor = .NaturianColor.darkGray
        
        seedStack.axis = .horizontal
        seedStack.alignment = .center
        seedStack.spacing = 3

        chatButton.setImage(UIImage(named: "chat_green"), for: .normal)
        
        finishedBtn.setTitle("Finished", for: .normal)
        finishedBtn.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 12)
        finishedBtn.setTitleColor(.white, for: .normal)
        finishedBtn.backgroundColor = .NaturianColor.treatmentGreen
        finishedBtn.lkCornerRadius = 13
        
        postImage.backgroundColor = .gray
        postImage.contentMode = .scaleAspectFill
        postImage.lkCornerRadius = 10
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 3
     
    }
    
    func layout() {
        
        contentView.addSubview(subview)

        subview.addSubview(postImage)
        subview.addSubview(chatButton)
        subview.addSubview(appliedStateBtn)
        subview.addSubview(talentStackView)
//        subview.addSubview(talentDescription)
        subview.addSubview(title)
        subview.addSubview(finishedBtn)
        subview.addSubview(seedStack)
        subview.addSubview(appliedStateBtn)
        
        talentStackView.addArrangedSubview(providerName)
        talentStackView.addArrangedSubview(seedStack)
        
        seedStack.addArrangedSubview(seedIcon)
        seedStack.addArrangedSubview(seedValue)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        talentStackView.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
//        talentDescription.translatesAutoresizingMaskIntoConstraints = false
        appliedStateBtn.translatesAutoresizingMaskIntoConstraints = false
        finishedBtn.translatesAutoresizingMaskIntoConstraints = false
        chatButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            subview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            subview.heightAnchor.constraint(equalToConstant: 175),
            
            title.topAnchor.constraint(equalTo: appliedStateBtn.topAnchor, constant: -1),
            title.leadingAnchor.constraint(equalTo: appliedStateBtn.trailingAnchor, constant: 6),
            title.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -18),
            
            // postImage
            postImage.topAnchor.constraint(equalTo: subview.topAnchor, constant: 20),
            postImage.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 18),
            postImage.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -20),
            postImage.widthAnchor.constraint(equalToConstant: 135),
            postImage.heightAnchor.constraint(equalToConstant: 135),
            
            // appliedStateBtn
            appliedStateBtn.topAnchor.constraint(equalTo: postImage.topAnchor),
            appliedStateBtn.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 14),
            appliedStateBtn.widthAnchor.constraint(equalToConstant: 16),
            appliedStateBtn.heightAnchor.constraint(equalToConstant: 16),
            
            // talentStack
            talentStackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            talentStackView.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            seedIcon.widthAnchor.constraint(equalToConstant: 12),
            seedIcon.heightAnchor.constraint(equalToConstant: 12),
            
            finishedBtn.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            finishedBtn.heightAnchor.constraint(equalToConstant: 28),
            finishedBtn.trailingAnchor.constraint(equalTo: chatButton.leadingAnchor, constant: -18),
            finishedBtn.leadingAnchor.constraint(equalTo: title.leadingAnchor),
    
            // chatButton
            chatButton.centerYAnchor.constraint(equalTo: finishedBtn.centerYAnchor),
            chatButton.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -18),
            chatButton.widthAnchor.constraint(equalToConstant: 26),
            chatButton.heightAnchor.constraint(equalToConstant: 26)

        ])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
