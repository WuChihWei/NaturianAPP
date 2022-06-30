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
    
    let postImage = UIImageView()
    let providerName = UILabel()
    let title = UILabel()
    let seedValue = UILabel()
    let talentDescription = UILabel()
    let locationImage = UIImageView()
    let locationLabel = UILabel()
    let category = UILabel()
    let genderIcon = UIImageView()
    
    private let nameStackView = UIStackView()
    private let talentStackView = UIStackView()
    private let locationStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textAlignment = .left
        title.text = "Title"
        
        seedValue.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        seedValue.textAlignment = .left
        seedValue.text = "70 Seeds"
        
        category.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        category.textAlignment = .center
        category.backgroundColor = .green
        category.text = "Category"
        
        talentDescription.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        talentDescription.numberOfLines = 2
        talentDescription.text = "I will teach you how reproduce plants in better ways."
        talentDescription.textAlignment = .justified
        
        providerName.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        providerName.textAlignment = .center
        providerName.text = "David"
        
        genderIcon.image = UIImage(named: "female")
        
        postImage.backgroundColor = .gray
        
        nameStackView.axis = .horizontal
        nameStackView.alignment = .center
        nameStackView.spacing = 3
        
        talentStackView.axis = .vertical
        talentStackView.alignment = .leading
        talentStackView.spacing = 3
        
        locationStackView.axis = .horizontal
        locationStackView.alignment = .center
        locationStackView.spacing = 3
        locationImage.image = UIImage(named: "location")
        
        locationLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        locationLabel.text = "Taichung City"
    }
    
    func layout() {
        
        contentView.addSubview(postImage)
        contentView.addSubview(talentDescription)
        contentView.addSubview(genderIcon)
        
        contentView.addSubview(talentStackView)
        contentView.addSubview(nameStackView)
        contentView.addSubview(locationStackView)
        
        postImage.translatesAutoresizingMaskIntoConstraints = false
        talentDescription.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        talentStackView.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        nameStackView.addArrangedSubview(genderIcon)
        nameStackView.addArrangedSubview(providerName)
        
        talentStackView.addArrangedSubview(title)
        talentStackView.addArrangedSubview(seedValue)
        talentStackView.addArrangedSubview(category)
        
        locationStackView.addArrangedSubview(locationImage)
        locationStackView.addArrangedSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            
            // postImage
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            postImage.widthAnchor.constraint(equalToConstant: 100),
            postImage.heightAnchor.constraint(equalToConstant: 100),
            
            genderIcon.widthAnchor.constraint(equalToConstant: 18),
            genderIcon.heightAnchor.constraint(equalToConstant: 18),
            
            // talentStack
            talentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            talentStackView.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 18),
            talentStackView.heightAnchor.constraint(equalToConstant: 50),
            
            // talentDescription
            talentDescription.topAnchor.constraint(equalTo: talentStackView.bottomAnchor, constant: 8),
            talentDescription.leadingAnchor.constraint(equalTo: talentStackView.leadingAnchor),
            talentDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            locationStackView.topAnchor.constraint(equalTo: talentDescription.bottomAnchor, constant: 12),
            locationStackView.trailingAnchor.constraint(equalTo: talentDescription.trailingAnchor),
            locationStackView.bottomAnchor.constraint(equalTo: nameStackView.bottomAnchor),
            locationImage.widthAnchor.constraint(equalToConstant: 18),
            locationImage.heightAnchor.constraint(equalToConstant: 18),
            
            // providerName
            nameStackView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            nameStackView.centerXAnchor.constraint(equalTo: postImage.centerXAnchor),
            nameStackView.heightAnchor.constraint(equalToConstant: 20),
            nameStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
