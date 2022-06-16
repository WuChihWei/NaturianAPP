//
//  PostArticleViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//

import UIKit

class PostArticleViewController: UIViewController {

    @IBOutlet weak var userAvatarUIImage: UIImageView!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
    }
    
    func style() {
        
        userAvatarUIImage.layer.cornerRadius = userAvatarUIImage.frame.width / 2
        
        postButton.layer.cornerRadius = 5
    }

}
