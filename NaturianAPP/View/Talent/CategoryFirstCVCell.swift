//
//  CategoryFirstCVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/14.
//

import UIKit

class CategoryFirstCVCell: UICollectionViewCell {
    
    static let identifer = "\(CategoryFirstCVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let tilteLB = UILabel()
    let iconView = UIImageView()
    let itemStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {

        tilteLB.textColor = .NaturianColor.darkGray
        tilteLB.font = UIFont(name: Roboto.bold.rawValue, size: 12)
        tilteLB.textAlignment = .center
        
        itemStackView.axis = .horizontal
        itemStackView.alignment = .center
        itemStackView.spacing = 6
    }
    
    func layout() {

        addSubview(itemStackView)
       
        itemStackView.addArrangedSubview(iconView)
        itemStackView.addArrangedSubview(tilteLB)

        itemStackView.translatesAutoresizingMaskIntoConstraints = false
//        cardview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
 
            itemStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            itemStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            iconView.heightAnchor.constraint(equalToConstant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            
//            tilteLB.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: -15),
            tilteLB.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])

    }
}
