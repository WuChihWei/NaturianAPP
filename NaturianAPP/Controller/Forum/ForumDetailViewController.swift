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
import Foundation
import FirebaseAuth

class ForumDetailViewController: UIViewController {
    
//    var talentManager = TalentManager()
    let userManager = UserManager()
    var forumManager = ForumManager()
    var db: Firestore?
    let userID = Auth.auth().currentUser?.uid
//        let userID = "2"

    private let tableView = UITableView()
    
    let addReplyBTN = UIButton()
    let closeButton = UIButton()
    var userInfo: UserModel!

    //    var talentArticles: [TalentArticle] = []
    var userModels: [UserModel] = []
//    var talentArticle: String = ""
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
        super.viewWillAppear(false)
        currentUserState()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
//        tableView.reloadData()
        findAuthorData()
        findReplies()
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
    
    func currentUserState() {
        
        userManager.listenUserData(userID: userID ?? "") { [weak self] result in
                
                switch result {

                case .success(let userModel):

                    self?.userInfo = userModel
                    
                    print(self?.userModels ?? "")
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
        vc.replyArticleDelegate = self
        vc.forumArticles = forumArticles
        //        self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    
    @objc func addToCollection(_ sender: UIButton) {
        
        if sender.isSelected == false {
            
            sender.setImage(UIImage(named: "greenLike"), for: .normal)
            sender.isSelected = true
//            setupLottie()

            userManager.addLikedForum(uid: self.userID ?? "", forumID: self.forumArticles.postArticleID ?? "") { [weak self] result in
                
                switch result {

                case .success:
                    
                    let newLikeValue = (self?.forumArticles.getLikedValue ?? 0) + 1
                    
                    self?.forumManager.updateLikeValue(forumID: self?.forumArticles.postArticleID ?? "", likeValue: newLikeValue) { [weak self] result in
                        
                        switch result {

                        case .success:
//                            self?.dismiss(animated: true)
                            print("success")

                        case .failure:
                            print("can't fetch data")
                            
                        }
                    }
                    self?.dismiss(animated: true)
                    
                case .failure:
                    print("can't fetch data")
                    
                }
            }
       
        } else {
            sender.isSelected = false
            sender.setImage(UIImage(named: "grayLike"), for: .normal)
            
            userManager.removeLikedForum(uid: self.userID ?? "", forumID: self.forumArticles.postArticleID ?? "") { [weak self] result in
                switch result {
                    
                case .success:
                    
                    let newLikeValue = self?.forumArticles.getLikedValue ?? 0
                    
                    self?.forumManager.updateLikeValue(forumID: self?.forumArticles.postArticleID ?? "", likeValue: newLikeValue) { [weak self] result in
                        
                        switch result {

                        case .success:
//                            self?.dismiss(animated: true)
                            print("success")

                        case .failure:
                            print("can't fetch data")
                            
                        }
                    }
                    
                    self?.dismiss(animated: true)
                    
                case .failure:
                    print("can't fetch data")
                    
                }
            }
        }
    }
    
    @objc func addToSeed(_ sender: UIButton) {
        
        if sender.isSelected == false {
            
            sender.setImage(UIImage(named: "greenSeed"), for: .normal)
            sender.isSelected = true
//            setupLottie()

            userManager.didGiveSeed(uid: self.userID ?? "",
                                    forumID: self.forumArticles.postArticleID ?? "") { [weak self] result in
                
                switch result {

                case .success:
                    
                    let newSeed = (self?.userInfo.seedValue ?? 0) - 1
                    
                    self?.userManager.updateSeedValue(uid: self?.userID ?? "",
                                                         seedValue: newSeed) { [weak self] result in
                        switch result {
                        case .success:
                            
                            let authorNewSeed = (self?.authorInfo.seedValue ?? 0) + 1
                            
                            self?.userManager.updateSeedValue(uid: self?.forumArticles.userID ?? "",
                                                                 seedValue: authorNewSeed) { [weak self] result in
                                switch result {
                                case .success:
                                    
                                    let forumValue = (self?.forumArticles.getSeedValue ?? 0) + 1
                                    
                                    self?.forumManager.updateSeedValue(forumID: self?.forumArticles.postArticleID ?? "",
                                                                         seedValue: forumValue) { [weak self] result in
                                        switch result {
                                        case .success:
//                                            self?.dismiss(animated: true)
                                            print("success")

                                        case .failure:
                                            print("can't fetch data")
                                        }
                                    }
//                                    self?.dismiss(animated: true)
                                    print("success")

                                case .failure:
                                    print("can't fetch data")
                                }
                            }
                            
//                            self?.dismiss(animated: true)
                            print("success")

                        case .failure:
                            print("can't fetch data")
                        }
                    }
                
                    self?.dismiss(animated: true)
                    
                case .failure:
                    print("can't fetch data")
                    
                }
            }

        } else {
            
            sender.isSelected = false
            sender.setImage(UIImage(named: "graySeed"), for: .normal)
            
            userManager.removeGiveSeed(uid: self.userID ?? "",
                                       forumID: self.forumArticles.postArticleID ?? "") { [weak self] result in
                switch result {
                    
                case .success:
                    
                    let previousSeed = self?.userInfo.seedValue ?? 0
                    
                    self?.userManager.updateSeedValue(uid: self?.userID ?? "",
                                                         seedValue: previousSeed) { [weak self] result in
                        switch result {
                        case .success:
                            
                            let authorPreviosSeed = self?.authorInfo.seedValue ?? 0
                            
                            self?.userManager.updateSeedValue(uid: self?.forumArticles.userID ?? "",
                                                                 seedValue: authorPreviosSeed) { [weak self] result in
                                switch result {
                                    
                                case .success:
                                    
                                    let forumValue = (self?.forumArticles.getSeedValue ?? 0)
                                    
                                    self?.forumManager.updateSeedValue(forumID: self?.forumArticles.postArticleID ?? "",
                                                                         seedValue: forumValue) { [weak self] result in
                                        switch result {
                                        case .success:
//                                            self?.dismiss(animated: true)
                                            print("success")

                                        case .failure:
                                            print("can't fetch data")
                                        }
                                    }
                                    
//                                    self?.dismiss(animated: true)
                                    print("success")

                                case .failure:
                                    print("can't fetch data")
                                }
                            }
//                            self?.dismiss(animated: true)
                            print("success")

                        case .failure:
                            print("can't fetch data")
                        }
                        
                    }
                 
                    self?.dismiss(animated: true)
                    
                case .failure:
                    print("can't fetch data")
                    
                }
            }

        }
    }
    
    func findReplies() {
        
            for replyID in forumArticles.replyIDs {
    
                forumManager.findRepliesData(replyID: replyID) { [weak self] result in
    
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
//            cell1.articleContent.lineBreakMode = NSLineBreakMode.byWordWrapping
//            cell1.articleContent.numberOfLines = 0
            
            cell1.articleContent.text = forumArticles.content?.replacingOccurrences(of: "\\n", with: "\n")
            
            cell1.title.text = forumArticles.title
            cell1.categoryBTN.setTitle(forumArticles.category, for: .normal)
            
            let photoUrl = forumArticles.images[0]
            cell1.postImage.kf.setImage(with: photoUrl)
            cell1.postImage.contentMode = .scaleAspectFill
            cell1.postImage.clipsToBounds = true
            cell1.authorLB.text = forumArticles.userInfo?.name
            let avatatUrl = URL(string: authorInfo?.userAvatar ?? "")
            cell1.avatarImage.kf.setImage(with: avatatUrl)
            cell1.avatarImage.contentMode = .scaleAspectFill
            cell1.avatarImage.clipsToBounds = true
            cell1.likeBtn.addTarget(self, action: #selector(addToCollection), for: .touchUpInside)
            cell1.seedBtn.addTarget(self, action: #selector(addToSeed), for: .touchUpInside)
            
            guard let likedID = self.forumArticles.postArticleID else { return UITableViewCell() }
            
            if self.userInfo.likedForumList.contains(likedID) {
                cell1.likeBtn.setImage(UIImage(named: "greenLike"), for: .normal)
                cell1.likeBtn.isSelected = true
            } else {
                cell1.likeBtn.setImage(UIImage(named: "grayLike"), for: .normal)
                cell1.likeBtn.isSelected = false
            }
            
            guard let seedID = self.forumArticles.postArticleID else { return UITableViewCell() }

            if self.userInfo.didGiveSeed.contains(seedID) {
                cell1.seedBtn.setImage(UIImage(named: "greenSeed"), for: .normal)
                cell1.seedBtn.isSelected = true
            } else {
                cell1.seedBtn.setImage(UIImage(named: "graySeed"), for: .normal)
                cell1.seedBtn.isSelected = false
            }
            
            return cell1
            
        case 1 :
            
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: ForumDetailReplyTBCell.identifer,
                                                            for: indexPath) as? ForumDetailReplyTBCell else { fatalError("can't find Cell") }
            cell2.contentView.layoutIfNeeded()
            cell2.clipsToBounds = true

            let newArray = self.repliedArticles.sorted {
                guard let d1 = $0.createdTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"),
                      let d2 = $1.createdTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss") else { return false }
                return d1 > d2
            }
            
            cell2.selectionStyle = .none
            cell2.replierName.text = newArray[indexPath.row].userInfo.name
            cell2.replyContent.text = newArray[indexPath.row].replyContent
        
            cell2.createdTimeLB.text = newArray[indexPath.row].createdTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            let replierUrl = URL(string: newArray[indexPath.row].userInfo.userAvatar ?? "")
            cell2.replierAvatar.kf.setImage(with: replierUrl)
 
            cell2.replierAvatar.contentMode = .scaleAspectFill
            cell2.replierAvatar.clipsToBounds = true
            
            return cell2
            
        default:
            
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: ForumDetailReplyTBCell.identifer,
                                                            for: indexPath) as? ForumDetailReplyTBCell else { fatalError("can't find Cell") }
            cell2.selectionStyle = .none
            return cell2
            
        }
    }
}

extension ForumDetailViewController: ReplyArticleDelegate {
    func replyArticle(repliedArticles: [ReplyModel]) {
        self.repliedArticles =  repliedArticles
        tableView.reloadData()
    }
}
