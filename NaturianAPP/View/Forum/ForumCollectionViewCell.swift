//
//  ForumCollectionViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit

class ForumCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.width / 2 - 10.0),
            height: Int(UIScreen.width / 2 - 10.0)))
        self.addSubview(imageView)
        
        titleLabel = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.width / 2 - 10.0),
            height: Int(UIScreen.width / 2 - 10.0)))
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
    
    func setUI() {
        
        imageView.backgroundColor = UIColor.gray
        
        titleLabel.textColor = UIColor.black
    }
    
    
}
