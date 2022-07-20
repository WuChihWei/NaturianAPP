//
//  ForumDetailViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//

import UIKit
import Kingfisher
import Foundation
import FirebaseAuth

class ForumDetailViewController: UIViewController {
    
    let userManager = UserManager()
    var forumManager = ForumManager()
    let userID = Auth.auth().currentUser?.uid
    //        let userID = "2"
    private let tableView = UITableView()
    
    let addReplyBTN = UIButton()
    let closeButton = UIButton()
    var userInfo: UserModel!
    
    var userModels: [UserModel] = []
    var forumArticles: ForumModel!
    var authorInfo: UserModel!
    var repliedArticles: [ReplyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        addReplyBTN.layer.cornerRadius = (addReplyBTN.bounds.width) / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        currentUserState()
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
                DispatchQueue.main.async {
                    
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
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
        present(vc, animated: true)
    }
    
    @objc func addToCollection(_ sender: UIButton) {
        
        switch sender.isSelected {
            
        case false:
            
            userManager.addLikedForum(uid: self.userID ?? "",
                                      forumID: self.forumArticles.postArticleID ?? "") { [weak self] result in
                
                switch result {
                    
                case .success:
                    
                    let newLikeValue = (self?.forumArticles.getLikedValue ?? 0) + 1
                    
                    self?.forumManager.updateLikeValue(forumID: self?.forumArticles.postArticleID ?? "",
                                                       likeValue: newLikeValue) { [weak self] result in
                        
                        switch result {
                            
                        case .success:
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
            
        case true:
            
            userManager.removeLikedForum(uid: self.userID ?? "",
                                         forumID: self.forumArticles.postArticleID ?? "") { [weak self] result in
                switch result {
                    
                case .success:
                    
                    let newLikeValue = self?.forumArticles.getLikedValue ?? 0
                    
                    self?.forumManager.updateLikeValue(forumID: self?.forumArticles.postArticleID ?? "",
                                                       likeValue: newLikeValue) { [weak self] result in
                        
                        switch result {
                            
                        case .success:
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
        
        let userSeeds = self.userInfo.seedValue ?? 0
        let authorSeeds = self.authorInfo.seedValue ?? 0
        let articleGetSeeds = self.forumArticles.getSeedValue ?? 0
        
        switch sender.isSelected {
            
        case false:
            userManager.didGiveSeed(uid: self.userID ?? "",
                                    forumID: self.forumArticles.postArticleID ?? "") { [weak self] result in
                
                switch result {
                    
                case .success:
                    
                    let newCommentSeed = userSeeds - 1
                    
                    self?.userManager.updateUserSeeds(uid: self?.userID ?? "",
                                                      seedValue: newCommentSeed) { [weak self] result in
                        switch result {
                        case .success:
                            
                            let authorNewSeed = authorSeeds + 1
                            
                            self?.userManager.updateUserSeeds(uid: self?.forumArticles.userID ?? "",
                                                              seedValue: authorNewSeed) { [weak self] result in
                                switch result {
                                case .success:
                                    
                                    let forumValue = articleGetSeeds + 1
                                    
                                    self?.updateForumSeeds(forumID: self?.forumArticles.postArticleID ?? "",
                                                           seedValue: forumValue)
                                    
                                case .failure:
                                    print("can't fetch data")
                                }
                            }
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
            
        case true:
            
            userManager.removeGiveSeed(uid: self.userID ?? "",
                                       forumID: self.forumArticles.postArticleID ?? "") { [weak self] result in
                switch result {
                    
                case .success:
                    
                    let previousSeed = userSeeds + 1
                    
                    self?.userManager.updateUserSeeds(uid: self?.userID ?? "",
                                                      seedValue: previousSeed) { [weak self] result in
                        switch result {
                            
                        case .success:
                            
                            let authorPreviosSeed = authorSeeds
                            self?.userManager.updateUserSeeds(uid: self?.forumArticles.userID ?? "",
                                                              seedValue: authorPreviosSeed) { [weak self] result in
                                switch result {
                                    
                                case .success:
                                    
                                    let forumValue = articleGetSeeds
                                    
                                    self?.updateForumSeeds(forumID: self?.forumArticles.postArticleID ?? "",
                                                           seedValue: forumValue)
                                    
                                    print("success")
                                    
                                case .failure:
                                    print("can't fetch data")
                                }
                            }
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
    
    private func updateForumSeeds(forumID: String, seedValue: Int) {
        forumManager.updateSeedValue(forumID: forumID,
                                     seedValue: seedValue) { [weak self] result in
            switch result {
                
            case .success:
                print("success")
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    private func findReplies() {
        
        for replyID in forumArticles.replyIDs {
            
            forumManager.findRepliesData(replyID: replyID) { [weak self] result in
                
                switch result {
                    
                case .success(let replyModel):
                    
                    self?.repliedArticles.append(replyModel)
                    
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
        
        tableView.register(ForumDetailPostTBCell.self,
                           forCellReuseIdentifier: ForumDetailPostTBCell.identifer)
        
        tableView.register(ForumDetailReplyTBCell.self,
                           forCellReuseIdentifier: ForumDetailReplyTBCell.identifer)
        
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
    }
    
    func layout() {
        
        view.addSubview(tableView)
        tableView.addSubview(addReplyBTN)
        tableView.addSubview(closeButton)
        
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                           paddingTop: 0, paddingLeft: 24, width: 36, height: 36)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        addReplyBTN.anchor(bottom: view.bottomAnchor, right: view.rightAnchor,
                           paddingBottom: 24, paddingRight: 24, width: 58, height: 58)
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
        
        switch section {
            
        case 0:
            return 1
        case 1:
            return repliedArticles.count
        default:
            break
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0 :
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: ForumDetailPostTBCell.identifer,
                                                            for: indexPath) as? ForumDetailPostTBCell else { fatalError("can't find Cell") }
            cell1.layoutIfNeeded()
            cell1.selectionStyle = .none
            cell1.contentView.layoutIfNeeded()
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
            
            switch self.userInfo.likedForumList.contains(likedID) {
            case true:
                cell1.likeBtn.isSelected = true
            case false:
                cell1.likeBtn.isSelected = false
            }
            
            guard let seedID = self.forumArticles.postArticleID else { return UITableViewCell() }
            
            switch self.userInfo.didGiveSeed.contains(seedID) {
            case true:
                cell1.seedBtn.isSelected = true
            case false:
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
            break
        }
        return UITableViewCell()
    }
}

extension ForumDetailViewController: ReplyArticleDelegate {
    func replyArticle(repliedArticles: [ReplyModel]) {
        self.repliedArticles =  repliedArticles
        tableView.reloadData()
    }
}
