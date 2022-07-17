//
//  MyCollectionVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/15.
//

import UIKit
import LZViewPager

class MyCollectionVC: UIViewController {

    var userModel: UserModel!
//    let viewPagers =  LZViewPager()
    let talentPageBtn = UIButton()
    let forumPageBtn = UIButton()
//    let closeButton = UIButton()

//    private let grayView = UIView()
    private var subControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        style()
        setUp()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func forumPage() {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "LikeForumVC") as? LikeForumVC else {

            fatalError("can't find LikeForumVC")
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func talentPage() {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "LikeTalentVC") as? LikeTalentVC else {

            fatalError("can't find LikeTalentVC")
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUp() {
        
        forumPageBtn.addTarget(self, action: #selector(forumPage), for: .touchUpInside)
        talentPageBtn.addTarget(self, action: #selector(talentPage), for: .touchUpInside)
    }
    
    func style() {
        // backTabBar
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        view.backgroundColor = .NaturianColor.lightGray
        talentPageBtn.lkCornerRadius = 15
        talentPageBtn.setImage(UIImage(named: "likeTalent"), for: .normal)
        talentPageBtn.backgroundColor = .NaturianColor.exerciseBlue
        talentPageBtn.titleLabel?.font = UIFont(name: Roboto.black.rawValue, size: 48)
        talentPageBtn.titleLabel?.textColor = .white

//        forumPageBtn.setTitle("Forum", for: .normal)
        forumPageBtn.setImage(UIImage(named: "likeForum"), for: .normal)
        forumPageBtn.titleLabel?.font = UIFont(name: Roboto.black.rawValue, size: 48)
        forumPageBtn.lkCornerRadius = 15
        forumPageBtn.titleLabel?.textColor = .white
        forumPageBtn.backgroundColor = .NaturianColor.foodYellow

    }
    
    func layout() {
        
//        view.addSubview(closeButton)
        view.addSubview(talentPageBtn)
        view.addSubview(forumPageBtn)

//        closeButton.translatesAutoresizingMaskIntoConstraints = false
        talentPageBtn.translatesAutoresizingMaskIntoConstraints = false
        forumPageBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
//            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
//            closeButton.heightAnchor.constraint(equalToConstant: 36),
//            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            talentPageBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            talentPageBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            talentPageBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            talentPageBtn.heightAnchor.constraint(equalToConstant: 175),

            forumPageBtn.topAnchor.constraint(equalTo: talentPageBtn.bottomAnchor, constant: 24),
            forumPageBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            forumPageBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            forumPageBtn.heightAnchor.constraint(equalToConstant: 175)
        ])
    }
}
