//
//  ForumReplyVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/2.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import Lottie

protocol ReplyArticleDelegate: AnyObject {
    func replyArticle(repliedArticles: [ReplyModel])
}

class ForumReplyVC: UITabBarController, UITextViewDelegate {
    
    weak var replyArticleDelegate: ReplyArticleDelegate?
        let currentUserID = Auth.auth().currentUser?.uid
//    let currentUserID = "2"
//    let currentUserID = "1"

    var forumManager = ForumManager()
    var repliedArticles: [ReplyModel] = []
    
    var userManager = UserManager()
    var userModels: UserModel?
    
    let subview = UIView()
    var backButton = UIButton()
    let replyLB = UILabel()
    let replyCotent = UITextView()
    let replyButton = UIButton()
    let cancelButton = UIButton()
    let actStack = UIStackView()
    let replyManager = ForumManager()
    var forumArticles: ForumModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyCotent.delegate = self
        setup()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Text Reply Content Here........."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func fetchUserData() {
        
        userManager.fetchUserData(userID: currentUserID ?? "" ) { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.userModels = userModel
                
                DispatchQueue.main.async {
                    self?.viewDidLoad()
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    func setupLottie() {
        let animationView = AnimationView(name: "lf20_xaazxgdm")
           animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
           animationView.center = self.view.center
           animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop

           view.addSubview(animationView)
           animationView.play()
    }
    
    @objc func replyArticle() {
        
        setupLottie()
        
        let createdTime = Date()
        let replyID = replyManager.forumReplyDatabase.document().documentID
        
        let userModel = UserModel(name: self.userModels?.name,
                                  userID: self.userModels?.userID,
                                  seedValue: self.userModels?.seedValue,
                                  gender: self.userModels?.gender,
                                  userAvatar: self.userModels?.userAvatar,
                                  appliedTalent: self.userModels?.appliedTalent ?? [],
                                  isAcceptedTalent: self.userModels?.isAcceptedTalent ?? [],
                                  blockList: self.userModels?.blockList ?? [],
                                  likedTalentList: self.userModels?.likedTalentList ?? [],
                                  likedForumList: self.userModels?.likedForumList ?? [],
                                  didGiveSeed: self.userModels?.didGiveSeed ?? [],
                                  email: self.userModels?.email
        )
        
        let replyModel = ReplyModel(replyID: replyID,
                                    replyContent: self.replyCotent.text,
                                    userID: currentUserID,
                                    createdTime: createdTime,
                                    userInfo: userModel)

        replyManager.addReplyData(replyForum: replyModel)
        
        forumArticles.replyIDs.append(replyID)
        replyManager.updateAplyIDs(articleID: forumArticles.postArticleID ?? "",
                                   repliedArticle: forumArticles) { [weak self] result in
            switch result {
                
            case .success:
                
                for replyID in self!.forumArticles.replyIDs {
                    
                    self!.forumManager.findRepliesData(replyID: replyID) { [weak self] result in
                        
                        switch result {
                            
                        case .success(let replyModel):
                            
                            self?.repliedArticles.append(replyModel)
                            
                            DispatchQueue.main.async {
                                self?.replyArticleDelegate?.replyArticle(repliedArticles: self?.repliedArticles ?? [])
                                self?.dismiss(animated: false)
                            }
                            
                        case .failure:
                            
                            print("can't fetch data")
                        }
                    }
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    func setup() {
        replyButton.addTarget(self, action: #selector(replyArticle), for: .touchUpInside)
        textViewDidBeginEditing(replyCotent)
        textViewDidBeginEditing(replyCotent)
    }
    
    func style() {
        
        view.backgroundColor = .clear
        subview.backgroundColor = .white
        subview.lkCornerRadius = 30
        subview.clipsToBounds = true
        subview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        backButton.setImage(UIImage(named: "dismiss"), for: .normal)
        
        replyLB.font = UIFont(name: Roboto.bold.rawValue, size: 30)
        replyLB.textColor = .NaturianColor.darkGray
        replyLB.text = "REPLY"
        //        descriptionText.textColor = UIColor.lightGray
        
        replyCotent.font = UIFont(name: Roboto.medium.rawValue, size: 16)
        replyCotent.textAlignment = .justified
        replyCotent.text = "Text Reply Content Here........."
        replyCotent.textColor = UIColor.lightGray
        
        replyButton.setTitle("Reply", for: .normal)
        replyButton.setTitleColor(.white, for: .normal)
        replyButton.backgroundColor = UIColor.NaturianColor.treatmentGreen
        
        replyButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 16)
        replyButton.lkCornerRadius = 24
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.setTitleColor(UIColor.NaturianColor.treatmentGreen, for: .normal)
        
        actStack.axis = .horizontal
        actStack.alignment = .center
        actStack.spacing = 14
        
    }
    
    func layout() {
        
        view.addSubview(subview)
        subview.addSubview(replyLB)
        subview.addSubview(replyCotent)
        subview.addSubview(backButton)
        subview.addSubview(actStack)
        
        actStack.addArrangedSubview(replyButton)
        actStack.addArrangedSubview(cancelButton)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        replyLB.translatesAutoresizingMaskIntoConstraints = false
        replyCotent.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        actStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            subview.heightAnchor.constraint(equalToConstant: 450),
            
            backButton.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            backButton.topAnchor.constraint(equalTo: subview.topAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.heightAnchor.constraint(equalToConstant: 42),
            
            replyLB.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            replyLB.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            
            replyCotent.leadingAnchor.constraint(equalTo: replyLB.leadingAnchor),
            replyCotent.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            replyCotent.topAnchor.constraint(equalTo: replyLB.bottomAnchor, constant: 24),
            replyCotent.bottomAnchor.constraint(equalTo: actStack.topAnchor, constant: -20),
            
            actStack.centerXAnchor.constraint(equalTo: subview.centerXAnchor),
            actStack.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -50),
            actStack.heightAnchor.constraint(equalToConstant: 48),
            replyButton.widthAnchor.constraint(equalToConstant: 130),
            replyButton.heightAnchor.constraint(equalToConstant: 48),
            cancelButton.widthAnchor.constraint(equalToConstant: 130),
            cancelButton.heightAnchor.constraint(equalToConstant: 48)
            
        ])
        
    }
}
