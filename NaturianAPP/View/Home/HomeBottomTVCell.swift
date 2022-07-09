//
//  HomeBottomTVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/7.
//

import UIKit

class HomeBottomTVCell: UITableViewCell {
    
    static let identifer = "\(HomeBottomTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var articleTitle = UILabel()
    var postImage = UIImageView()
    var articleContent = UILabel()
    let subview = UIView()
    
    let likeBtn = UIButton()
    let likeLB = UILabel()
    let seedBtn = UIButton()
    let seedLB = UILabel()
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
                
        backgroundColor = .white
        
        postImage.backgroundColor = .NaturianColor.lightGray
        postImage.lkBorderColor = .NaturianColor.darkGray
        postImage.lkBorderWidth = 1
        postImage.lkCornerRadius = 10
        
        articleTitle.text = "Make Organic Food"
        articleTitle.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        articleTitle.textColor = .NaturianColor.darkGray
        articleContent.numberOfLines = 1

        articleContent.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        articleContent.textColor = .NaturianColor.darkGray
        articleContent.numberOfLines = 0
        articleContent.text = "Describe your talent herePlease describe your talent herePlease describe your talent herePlease describe."
        articleContent.textAlignment = .justified
        articleContent.numberOfLines = 3
        
        
        likeBtn.setImage(UIImage(named: "liked"), for: .normal)
        likeLB.text = "321"
        likeLB.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        likeLB.textColor = .NaturianColor.navigationGray
        seedBtn.setImage(UIImage(named: "seed_green"), for: .normal)
        seedLB.text = "123"
        seedLB.font = UIFont(name: Roboto.medium.rawValue, size: 12)
        seedLB.textColor = .NaturianColor.navigationGray
        
        likestack.axis = .horizontal
        likestack.alignment = .trailing
        likestack.spacing = 4
        
        seedstack.axis = .horizontal
        seedstack.alignment = .trailing
        seedstack.spacing = 4
        
        subview.lkCornerRadius = 30
        contentView.lkCornerRadius = 30
    }
    
    func layout() {
        
        contentView.addSubview(articleTitle)
        contentView.addSubview(postImage)
        contentView.addSubview(articleContent)
        contentView.addSubview(likestack)
        contentView.addSubview(seedstack)

        likestack.addArrangedSubview(likeBtn)
        likestack.addArrangedSubview(likeLB)
        seedstack.addArrangedSubview(seedBtn)
        seedstack.addArrangedSubview(seedLB)
        
        likestack.translatesAutoresizingMaskIntoConstraints = false
        seedstack.translatesAutoresizingMaskIntoConstraints = false
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        articleContent.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
  
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            postImage.widthAnchor.constraint(equalToConstant: 94),
            postImage.heightAnchor.constraint(equalToConstant: 94),
            postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
     
            articleContent.leadingAnchor.constraint(equalTo: articleTitle.leadingAnchor),
            articleContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            articleContent.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 10),
       
            
            articleTitle.topAnchor.constraint(equalTo: postImage.topAnchor),
            articleTitle.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 20),
            articleTitle.heightAnchor.constraint(equalToConstant: 14),
            articleTitle.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            
            
            seedstack.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            seedstack.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            seedstack.heightAnchor.constraint(equalToConstant: 16),
            seedBtn.widthAnchor.constraint(equalToConstant: 16),
            
            likestack.bottomAnchor.constraint(equalTo: seedstack.bottomAnchor),
            likestack.trailingAnchor.constraint(equalTo: seedstack.leadingAnchor, constant: -10),
            likestack.heightAnchor.constraint(equalToConstant: 16),
            likeBtn.widthAnchor.constraint(equalToConstant: 16)
            
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
