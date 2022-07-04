//
//  ForumDetailViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import SwiftUI

class ForumDetailViewController: UIViewController {
    
    var talentManager = TalentManager()
    var forumManager = ForumManager()
    var db: Firestore?
    
    private let tableView = UITableView()
    
    let addReplyBTN = UIButton()
    let closeButton = UIButton()
    
    //    var talentArticles: [TalentArticle] = []
    var userManager = UserManager()
    var userModels: [UserModel] = []
    var talentArticle: String = ""
    var searchController: UISearchController!
    var forumArticles: ForumModel!
    var authorInfo: UserModel!
    var repliedArticles: [ReplyModel] = []
    var replyAuthor: UserModel!
    var replyAuthors: [UserModel] = []
    
    
    //    var replyArray: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        
        tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        tableView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        addReplyBTN.layer.cornerRadius = (addReplyBTN.bounds.width) / 2
        
        //        closeButton.lkCornerRadius = closeButton.bounds.width / 2
        //        closeButton.lkBorderWidth = 1
        //        closeButton.lkBorderColor = .darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true

        findAuthorData()
        findReplies()
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func findAuthorData() {
        
        userManager.fetchUserData(userID: forumArticles.userID ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.authorInfo = userModel
                
                print(self?.authorInfo ?? "")
                DispatchQueue.main.async {
                    
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    // fetch userinfo based on replyID.userID -> repliedArticles will equal to replyAuthors+1 when repliers > 1
//    func findReplies() {
//
//        for replyID in forumArticles.replyIDs {
//
//            forumManager.findRepliesData(replyID: replyID) {
//
//                [weak self] result in
//
//                switch result {
//
//                case .success(let replyModel):
//
//                    self?.repliedArticles.append(replyModel)
//
//                    for repliedArticle in self?.repliedArticles ?? [] {
//
//                        self?.userManager.fetchUserData(userID: repliedArticle.userID  ?? "") { [weak self] result in
//
//                            switch result {
//
//                            case .success(let replyModel):
//
//                                self?.replyAuthors.append(replyModel)
//
//                                print(self?.replyAuthors ?? "")
//                                DispatchQueue.main.async {
//                                    self?.viewDidLoad()
//                                }
//
//                            case .failure:
//                                print("can't fetch data")
//                            }
//                        }
//                    }
//                    print(self?.repliedArticles as Any)
//
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//
//                case .failure:
//                    
//                    print("can't fetch data")
//                }
//            }
//        }
//    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func showReplyPage() {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ForumReplyVC") as? ForumReplyVC else {
            
            fatalError("can't find ForumReplyVC")
        }
        
        vc.forumArticles = forumArticles
        //        self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    
    func findReplies() {
        
            for replyID in forumArticles.replyIDs {
    
                forumManager.findRepliesData(replyID: replyID) {
    
                    [weak self] result in
    
                    switch result {
    
                    case .success(let replyModel):
    
                        self?.repliedArticles.append(replyModel)
    
                        print(self?.repliedArticles as Any)
    
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
    
                    case .failure:
    
                        print("can't fetch data")
                    }
                }
            }
        }
    
    func setUp() {
        
        tableView.register(ForumDetailPostTBCell.self, forCellReuseIdentifier: ForumDetailPostTBCell.identifer)
        
        tableView.register(ForumDetailReplyTBCell.self, forCellReuseIdentifier: ForumDetailReplyTBCell.identifer)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        addReplyBTN.addTarget(self, action: #selector(showReplyPage), for: .touchUpInside)
        
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
    }
    
    func style() {
        
        // addButton
        addReplyBTN.setImage(UIImage(named: "reply"), for: .normal)
        addReplyBTN.backgroundColor = .NaturianColor.treatmentGreen
        // close button
        closeButton.setImage(UIImage(named: "back_white"), for: .normal)
        // tableView
        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        // tableView.bounces = false
    }
    
    func layout() {
        
        addReplyBTN.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(closeButton)
        
        view.addSubview(tableView)
        //        subview.addSubview(tableView)
        tableView.addSubview(addReplyBTN)
        
        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            // addTalentButton
            addReplyBTN.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            addReplyBTN.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addReplyBTN.widthAnchor.constraint(equalToConstant: 58),
            addReplyBTN.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}

extension ForumDetailViewController: UITableViewDelegate {
    
}

extension ForumDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1 } else {
                
                return repliedArticles.count
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0 :
            
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: ForumDetailPostTBCell.identifer,
                                                            for: indexPath) as? ForumDetailPostTBCell else { fatalError("can't find Cell") }
            cell1.layoutIfNeeded()
            cell1.selectionStyle = .none
            cell1.contentView.layoutIfNeeded()
            cell1.articleContent.text = forumArticles.content
            cell1.title.text = forumArticles.title
            cell1.categoryBTN.setTitle(forumArticles.category, for: .normal)
            
            let photoUrl = forumArticles.images[0]
            cell1.postImage.kf.setImage(with: photoUrl)
            cell1.postImage.contentMode = .scaleAspectFill
            cell1.postImage.clipsToBounds = true
            
            let avatatUrl = authorInfo?.userAvatar
            cell1.avatarImage.kf.setImage(with: avatatUrl)
            cell1.avatarImage.contentMode = .scaleAspectFill
            cell1.avatarImage.clipsToBounds = true
            
            switch forumArticles.category {
                
            case "Food":
                cell1.categoryBTN.backgroundColor = .NaturianColor.foodYellow
                addReplyBTN.backgroundColor = .NaturianColor.foodYellow
                cell1.avatarImage.lkBorderColor = .NaturianColor.foodYellow
            case "Plant":
                cell1.categoryBTN.backgroundColor = .NaturianColor.plantGreen
                addReplyBTN.backgroundColor = .NaturianColor.plantGreen
                cell1.avatarImage.lkBorderColor = .NaturianColor.plantGreen
                
            case "Adventure":
                cell1.categoryBTN.backgroundColor = .NaturianColor.adventurePink
                addReplyBTN.backgroundColor = .NaturianColor.adventurePink
                cell1.avatarImage.lkBorderColor = .NaturianColor.adventurePink
                
            case "Grocery":
                cell1.categoryBTN.backgroundColor = .NaturianColor.groceryBlue
                addReplyBTN.backgroundColor = .NaturianColor.groceryBlue
                cell1.avatarImage.lkBorderColor = .NaturianColor.groceryBlue
                
            case "Exercise":
                cell1.categoryBTN.backgroundColor = .NaturianColor.exerciseBlue
                addReplyBTN.backgroundColor = .NaturianColor.exerciseBlue
                cell1.avatarImage.lkBorderColor = .NaturianColor.exerciseBlue
                
            case "Treatment":
                cell1.categoryBTN.backgroundColor = .NaturianColor.treatmentGreen
                addReplyBTN.backgroundColor = .NaturianColor.treatmentGreen
                cell1.avatarImage.lkBorderColor = .NaturianColor.treatmentGreen
                
            default:
                break
                
            }
            
            return cell1
            
        case 1 :
            
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: ForumDetailReplyTBCell.identifer,
                                                            for: indexPath) as? ForumDetailReplyTBCell else { fatalError("can't find Cell") }
            cell2.contentView.layoutIfNeeded()
            cell2.clipsToBounds = true

            cell2.selectionStyle = .none
            cell2.replierName.text = repliedArticles[indexPath.row].userInfo.name
            cell2.replyContent.text = repliedArticles[indexPath.row].replyContent

            let replierUrl = repliedArticles[indexPath.row].userInfo.userAvatar
            cell2.replierAvatar.kf.setImage(with: replierUrl)
            cell2.replierAvatar.contentMode = .scaleAspectFill
            cell2.replierAvatar.clipsToBounds = true
            
            return cell2
            
        default:
            
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: ForumDetailReplyTBCell.identifer,
                                                            for: indexPath) as? ForumDetailReplyTBCell else { fatalError("can't find Cell") }
            cell2.selectionStyle = .none
            
//            cell2.
            return cell2
            
        }
    }
}
