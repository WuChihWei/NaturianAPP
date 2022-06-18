//
//  OthersTalentTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit

class OthersTalentTableViewCell: UITableViewCell {
    
    static let identifer = "\(OthersTalentTableViewCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView()
    let title = UILabel()
    let seedValue = UILabel()
    let talentDescription = UILabel()
    let messageAmount = UIButton()
    
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
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textAlignment = .left
        title.text = "Title"
        
        seedValue.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        seedValue.textAlignment = .left
        seedValue.text = "70 Seeds"
        
        talentDescription.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        talentDescription.numberOfLines = 2
        talentDescription.text = "I will teach you how reproduce plants in better ways."
        talentDescription.textAlignment = .justified

        postImage.backgroundColor = .gray
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 3
        
    }
    
    func layout() {
        
        contentView.addSubview(postImage)
        contentView.addSubview(talentDescription)
        contentView.addSubview(messageAmount)
        
        contentView.addSubview(talentStackView)
        talentStackView.addArrangedSubview(title)
        talentStackView.addArrangedSubview(seedValue)
        
        postImage.translatesAutoresizingMaskIntoConstraints = false
        talentDescription.translatesAutoresizingMaskIntoConstraints = false
        talentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // postImage
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            postImage.widthAnchor.constraint(equalToConstant: 100),
            postImage.heightAnchor.constraint(equalToConstant: 100),
            postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            
            // talentStack
            talentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            talentStackView.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 18),
            talentStackView.heightAnchor.constraint(equalToConstant: 50),
            
            // talentDescription
            talentDescription.topAnchor.constraint(equalTo: talentStackView.bottomAnchor, constant: 8),
            talentDescription.leadingAnchor.constraint(equalTo: talentStackView.leadingAnchor),
            talentDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)         
        ])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
