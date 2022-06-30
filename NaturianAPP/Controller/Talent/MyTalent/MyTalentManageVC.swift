//
//  TalentManageViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/17.
//

import UIKit

class MyTalentManageVC: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var othersView: UIView!
    
    var userModel: UserModel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.alpha = 1
        othersView.alpha = 0
        
        style()
        setUp()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func swifthView(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            myView.alpha = 1
            othersView.alpha = 0
        
        } else {
            
            othersView.alpha = 1
            myView.alpha = 0
            
        }
    }
    
    func setUp() {
        
    }
    
    func style() {
        // backTabBar
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
    }
    
    func layout() {
        
    }
    
}