//
//  ForumLobbyTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit

class ForumLobbyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorAvatarUIImage: UIImageView!
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var MessageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        authorAvatarUIImage.layer.cornerRadius = authorAvatarUIImage.frame.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
