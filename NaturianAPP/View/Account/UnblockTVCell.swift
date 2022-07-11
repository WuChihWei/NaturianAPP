//
//  UnblockTVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/10.
//

import UIKit

class UnblockTVCell: UITableViewCell {

    static let identifer = "\(UnblockTVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLabel = UILabel()
    let unBlockLB = UILabel()
    let blackView = UIView()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        nameLabel.font = UIFont(name: Roboto.bold.rawValue, size: 18)
        nameLabel.textAlignment = .left
        nameLabel.text = "Title"
        nameLabel.textColor = .NaturianColor.darkGray
        
        unBlockLB.font = UIFont(name: Roboto.bold.rawValue, size: 18)
        unBlockLB.textAlignment = .left
        unBlockLB.text = "Unblock"
        unBlockLB.textColor = .NaturianColor.navigationGray
        
        blackView.backgroundColor = .NaturianColor.navigationGray
    }
    
    func layout() {
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(unBlockLB)
        contentView.addSubview(blackView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        unBlockLB.translatesAutoresizingMaskIntoConstraints = false
        
        blackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            unBlockLB.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unBlockLB.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            contentView.heightAnchor.constraint(equalToConstant: 98),
            
            blackView.heightAnchor.constraint(equalToConstant: 1),
            blackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
            blackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
