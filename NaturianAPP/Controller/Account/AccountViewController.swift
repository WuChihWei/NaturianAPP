//
//  AccountViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/15.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
    }
    
}
