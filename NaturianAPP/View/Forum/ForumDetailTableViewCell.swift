//
//  ForumDetailTableViewCell.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//

import UIKit

class ForumDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var replyTimeLabel: UILabel!
    @IBOutlet weak var replierNameLabel: UILabel!
    @IBOutlet weak var replyContent: UILabel!
    @IBOutlet weak var avatarUIImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
