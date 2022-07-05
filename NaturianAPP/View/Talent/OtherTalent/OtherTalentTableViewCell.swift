//
//  OtherTalentTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import UIKit

class OtherTalentTableViewCell: UITableViewCell {
    
    static let identifer = "\(OtherTalentTableViewCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView()
//    let categoryBTN = UIButton()
    let title = UILabel()
    let appliedStateBtn = UIButton()
    let talentDescription = UILabel()
    var contactButton = UIButton()
    let seedValue = UILabel()
    let seedIcon = UIImageView()
    let providerName = UILabel()
    
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
        
        seedValue.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        seedValue.textAlignment = .left
        seedValue.text = "70"
        seedValue.textColor = .NaturianColor.navigationGray
        seedIcon.image = UIImage(named: "seed_gray")
        
        providerName.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        providerName.textAlignment = .left
        providerName.text = "David"
        providerName.textColor = .NaturianColor.darkGray
        
        seedStack.axis = .horizontal
        seedStack.alignment = .center
        seedStack.spacing = 3
        
        talentDescription.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        talentDescription.numberOfLines = 2
        talentDescription.text = "I will teach you how reproduce plants in better ways."
        talentDescription.textAlignment = .justified
        talentDescription.textColor = .NaturianColor.darkGray
        
        contactButton.setTitle("Contact", for: .normal)
        contactButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 12)
   
        contactButton.setTitleColor(.white, for: .normal)
        contactButton.backgroundColor = .NaturianColor.treatmentGreen
        contactButton.lkCornerRadius = 13
        
        postImage.backgroundColor = .gray
        postImage.contentMode = .scaleAspectFill
        postImage.lkCornerRadius = 10
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 0
     
    }
    
    func layout() {
        
        contentView.addSubview(subview)

        subview.addSubview(postImage)
        subview.addSubview(appliedStateBtn)
        subview.addSubview(talentStackView)
        subview.addSubview(talentDescription)
        subview.addSubview(title)
        subview.addSubview(contactButton)
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
        talentDescription.translatesAutoresizingMaskIntoConstraints = false
        appliedStateBtn.translatesAutoresizingMaskIntoConstraints = false
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        
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

            // talentDescription
            talentDescription.topAnchor.constraint(equalTo: talentStackView.bottomAnchor, constant: 3),
            talentDescription.leadingAnchor.constraint(equalTo: talentStackView.leadingAnchor),
            talentDescription.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            
            contactButton.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            contactButton.heightAnchor.constraint(equalToConstant: 26),
            contactButton.trailingAnchor.constraint(equalTo: appliedStateBtn.leadingAnchor, constant: -20),
            contactButton.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
            appliedStateBtn.centerYAnchor.constraint(equalTo: contactButton.centerYAnchor),
            appliedStateBtn.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            appliedStateBtn.widthAnchor.constraint(equalToConstant: 26),
            appliedStateBtn.heightAnchor.constraint(equalToConstant: 26)

        ])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
