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
    let categoryLabel = UILabel()
    let appliedStateBtn = UIButton()
    let talentTitle = UILabel()
    var contactButton = UIButton()
    var cancelButton = UIButton()
    let buttonStack = UIStackView()
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
        
        //        contentView.backgroundColor = .darkGray
        talentTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        talentTitle.textAlignment = .left
        talentTitle.text = "Title"
        
        categoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        categoryLabel.textAlignment = .center
        categoryLabel.backgroundColor = .green
        categoryLabel.text = "Category"
        
        appliedStateBtn.setTitle("", for: .normal)
        appliedStateBtn.backgroundColor = .lightGray
        appliedStateBtn.layer.cornerRadius = 17
//        appliedStateBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
        
        contactButton.setTitle("Contact", for: .normal)
        contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        contactButton.lkBorderColor = .black
        contactButton.lkBorderWidth = 1
        contactButton.setTitleColor(.black, for: .normal)
        contactButton.backgroundColor = .green
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cancelButton.lkBorderColor = .black
        cancelButton.lkBorderWidth = 1
        cancelButton.setTitleColor(.black, for: .normal)

        postImage.backgroundColor = .gray
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 3
        
        buttonStack.axis = .horizontal
        buttonStack.alignment = .trailing
        buttonStack.spacing = 10
    }
    
    func layout() {
        
        contentView.addSubview(postImage)
        contentView.addSubview(appliedStateBtn)
        contentView.addSubview(talentStackView)
        contentView.addSubview(buttonStack)
        
        talentStackView.addArrangedSubview(talentTitle)
        talentStackView.addArrangedSubview(categoryLabel)
        
        buttonStack.addArrangedSubview(contactButton)
        buttonStack.addArrangedSubview(cancelButton)
        
        postImage.translatesAutoresizingMaskIntoConstraints = false
        talentStackView.translatesAutoresizingMaskIntoConstraints = false
        appliedStateBtn.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // postImage
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            postImage.widthAnchor.constraint(equalToConstant: 100),
            postImage.heightAnchor.constraint(equalToConstant: 100),
            postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // talentStack
            talentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            talentStackView.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 18),
            talentStackView.heightAnchor.constraint(equalToConstant: 50),
                        
            // messageAmount
            appliedStateBtn.topAnchor.constraint(equalTo: postImage.topAnchor),
            appliedStateBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            appliedStateBtn.widthAnchor.constraint(equalToConstant: 30),
            appliedStateBtn.heightAnchor.constraint(equalToConstant: 30),
            
            contactButton.widthAnchor.constraint(equalToConstant: 80),
            cancelButton.widthAnchor.constraint(equalToConstant: 80),
            buttonStack.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: appliedStateBtn.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 22)
        ])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
