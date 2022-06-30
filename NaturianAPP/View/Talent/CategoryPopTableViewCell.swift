//
//  CategoryPopTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/22.
//

import UIKit

class CategoryPopTableViewCell: UITableViewCell {

    static let identifer = "\(CategoryPopTableViewCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let categoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        categoryLabel.textAlignment = .left
    }
    
    func layout() {
        
        contentView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        ])
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
