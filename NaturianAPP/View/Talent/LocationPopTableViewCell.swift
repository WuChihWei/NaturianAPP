//
//  LocationPopTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/22.
//

import UIKit

class LocationPopTableViewCell: UITableViewCell {
    
    static let identifer = "\(LocationPopTableViewCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let locationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {
        
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        locationLabel.textAlignment = .left
    }
    
    func layout() {
        
        contentView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            locationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        ])
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
