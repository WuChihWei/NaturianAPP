//
//  HomeCVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/6.
//

import UIKit

class HomeCVCell: UICollectionViewCell {
    
    static let identifer = "\(HomeCVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tilteLB = UILabel()
    let cardview = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        styleObject()
        layout()
    }
    
    func setup() {
        
    }
    
    func styleObject() {

        tilteLB.textColor = .white
        tilteLB.font = UIFont(name: Roboto.black.rawValue, size: 24)
        tilteLB.textAlignment = .center
        
    }
    
    func layout() {

        addSubview(cardview)
        cardview.addSubview(tilteLB)
        tilteLB.translatesAutoresizingMaskIntoConstraints = false
        cardview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            cardview.topAnchor.constraint(equalTo: self.topAnchor),
            cardview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cardview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            tilteLB.bottomAnchor.constraint(equalTo: cardview.bottomAnchor, constant: -15),
            tilteLB.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

    }
}
