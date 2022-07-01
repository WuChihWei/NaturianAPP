//
//  ForumDetailPostTBCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/1.
//

import UIKit

class ForumDetailPostTBCell: UITableViewCell {
    
    static let identifer = "\(ForumDetailPostTBCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView()
    let avatarImage = UIImageView()
    
    let title = UILabel()
    let categoryBTN = UIButton()
    
    let articleContent = UILabel()
    let authorLB = UILabel()
    
    let dottedLine = UIImageView()
    let solidLine = UIView()
    let likeBtn = UIButton()
    let seedBtn = UIButton()
    let buttonStack = UIStackView()
    
    //    private let nameStackView = UIStackView()
    //    private let articleStack = UIStackView()
    //    private let locationStackView = UIStackView()
    //    let likestack = UIStackView()
    //    let seedstack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func ovveride() {
        
    }
    
    func styleObject() {
        
        postImage.image = UIImage(named: "weave")
        postImage.contentMode = .scaleAspectFill

        avatarImage.image = UIImage(named: "")
        avatarImage.lkBorderColor = .white
        avatarImage.lkCornerRadius = 37
        avatarImage.lkBorderWidth = 2
        avatarImage.backgroundColor = .NaturianColor.lightGray
        
        title.font = UIFont(name: Roboto.bold.rawValue, size: 28)
        title.textAlignment = .left
        title.text = "This is title"
        title.textColor = .NaturianColor.darkGray
        
        categoryBTN.titleLabel?.font = UIFont(name: Roboto.medium.rawValue, size: 14)
        categoryBTN.titleLabel?.textAlignment = .center
        categoryBTN.setTitle("Food", for: .normal)
        categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
        categoryBTN.lkCornerRadius = 5
        
        title.numberOfLines = 0
        
        articleContent.font = UIFont(name: Roboto.regular.rawValue, size: 16)
        articleContent.textColor = .NaturianColor.darkGray
        articleContent.numberOfLines = 0
        articleContent.text = "Describe your talent herePlease describe your talent herePlease describe your talent herePlease describe."
        
        articleContent.textAlignment = .justified
        
        authorLB.font = UIFont(name: Roboto.regular.rawValue, size: 14)
        authorLB.textColor = .NaturianColor.darkGray
        authorLB.text = "Writen By : Linda"
        
        likeBtn.setImage(UIImage(named: "liked"), for: .normal)
        
//        let imgView: UIImageView = UIImageView(frame: CGRect(x: 0, y: -10, width: contentView.bounds.width, height: 10))
//        dottedLine.addSubview(imgView)
//        UIGraphicsBeginImageContext(imgView.frame.size) // 位图上下文绘制区域
//        imgView.image?.draw(in: contentView.bounds)
//        let context: CGContext = UIGraphicsGetCurrentContext()!
//        context.setLineCap(CGLineCap.square)
//        let lengths: [CGFloat] = [5, 10] // 绘制 跳过 无限循环
//        context.setStrokeColor(UIColor.NaturianColor.darkGray.cgColor)
//        context.setLineWidth(3)
//        context.setLineDash(phase: 0, lengths: lengths)
//        context.move(to: CGPoint(x: 0, y: 10))
//        context.addLine(to: CGPoint(x: self.contentView.bounds.width, y: 10))
//
//        context.strokePath()
//        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        dottedLine.image = UIImage(named: "dottedLine")
        solidLine.backgroundColor = .black
        
        seedBtn.setImage(UIImage(named: "seed_green"), for: .normal)
        
        buttonStack.axis = .horizontal
        buttonStack.alignment = .bottom
        buttonStack.spacing = 20
    }
    
    func layout() {
        
        contentView.addSubview(postImage)
        postImage.addSubview(avatarImage)
        //        contentView.addSubview(userAvatar)
        contentView.addSubview(title)
        contentView.addSubview(categoryBTN)
        contentView.addSubview(articleContent)
        contentView.addSubview(authorLB)
        contentView.addSubview(dottedLine)
        contentView.addSubview(buttonStack)
        contentView.addSubview(solidLine)
        
        buttonStack.addArrangedSubview(likeBtn)
        buttonStack.addArrangedSubview(seedBtn)
        
        postImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        title.translatesAutoresizingMaskIntoConstraints = false
        //        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        categoryBTN.translatesAutoresizingMaskIntoConstraints = false
        articleContent.translatesAutoresizingMaskIntoConstraints = false
        authorLB.translatesAutoresizingMaskIntoConstraints = false
        dottedLine.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        solidLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            postImage.heightAnchor.constraint(equalToConstant: 450),
            
            avatarImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            avatarImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            avatarImage.heightAnchor.constraint(equalToConstant: 74),
            avatarImage.widthAnchor.constraint(equalToConstant: 74),
            
            title.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 24),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            categoryBTN.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            categoryBTN.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            categoryBTN.widthAnchor.constraint(equalToConstant: 90),
            categoryBTN.heightAnchor.constraint(equalToConstant: 24),
            
            articleContent.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            articleContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            articleContent.topAnchor.constraint(equalTo: categoryBTN.bottomAnchor, constant: 10),
            
            authorLB.topAnchor.constraint(equalTo: articleContent.bottomAnchor, constant: 60),
            authorLB.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            authorLB.heightAnchor.constraint(equalToConstant: 14),
            
            dottedLine.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            dottedLine.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            dottedLine.heightAnchor.constraint(equalToConstant: 2),
            dottedLine.topAnchor.constraint(equalTo: authorLB.bottomAnchor, constant: 8),
            
            buttonStack.trailingAnchor.constraint(equalTo: dottedLine.trailingAnchor),
            buttonStack.topAnchor.constraint(equalTo: dottedLine.bottomAnchor, constant: 9),
            buttonStack.heightAnchor.constraint(equalToConstant: 28),
            likeBtn.widthAnchor.constraint(equalToConstant: 28),
            seedBtn.widthAnchor.constraint(equalToConstant: 28),
            
            solidLine.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 9),
            solidLine.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            solidLine.trailingAnchor.constraint(equalTo: articleContent.trailingAnchor),
            solidLine.heightAnchor.constraint(equalToConstant: 1),
            solidLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
