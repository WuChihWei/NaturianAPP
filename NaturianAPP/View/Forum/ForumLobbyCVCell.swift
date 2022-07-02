//
//  ForumLobbyCVCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/2.
//

import UIKit

class ForumLobbyCVCell: UICollectionViewCell {
    
    static let identifer = "\(ForumLobbyCVCell.self)"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tilteLB = UILabel()
    let cardview = UIView()

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
        tilteLB.font = UIFont(name: Roboto.black.rawValue, size: 22)
        tilteLB.textAlignment = .center
    }
    
    func layout() {

        addSubview(tilteLB)
        tilteLB.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tilteLB.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            tilteLB.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

    }
}
