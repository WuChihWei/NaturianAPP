//
//  LikeForumVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/15.
//

import UIKit
import Kingfisher
import FirebaseAuth
import AuthenticationServices

class LikeForumVC: UIViewController {

    let userManager = UserManager()
    let forumManager = ForumManager()
    let subview = UIView()
    var userInfo: UserModel!

    let closeButton = UIButton()
    let titleLB = UILabel()
    var forumAricles: [ForumModel] = []

    let userID = Auth.auth().currentUser?.uid
//    let userID = "2"
//    let userID = "1"

    var userModels: UserModel!
    private var blockUserIDs: [UserModel] = []

    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        setUp()
        style()
        layout()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        currentUserState()
//        fetchBlockInfo()
//        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: false)
    }
    func setUp() {
        
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        
        tableView.register(LikeForumTVCell.self, forCellReuseIdentifier: LikeForumTVCell.identifer)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func currentUserState() {
        
        userManager.listenUserData(userID: userID ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let userModel):
                
                self?.userInfo = userModel
                
                for forumID in self?.userInfo.likedForumList ?? [] {
                    
                    self?.forumManager.fetchMyLikeData(articleID: forumID) { [weak self] result in
                        
                        switch result {
                            
                        case .success(let forumModel):
                            
                            self?.forumAricles.append(forumModel)
                            
                            print(self?.forumAricles as Any)
                            
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                            
                        case .failure:
                            
                            print("can't fetch data")
                        }
                    }
                }
                print(self?.userModels ?? "")
                DispatchQueue.main.async {
                    
                    self?.viewDidLoad()
                }
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    func style() {
        subview.backgroundColor = .NaturianColor.lightGray

        closeButton.setImage(UIImage(named: "back_gray"), for: .normal)
        
        titleLB.text = "Favorite Article"
        titleLB.font = UIFont(name: Roboto.bold.rawValue, size: 14)
        
        tableView.backgroundColor = .NaturianColor.lightGray
        subview.lkBorderWidth = 1
        subview.lkBorderColor = .NaturianColor.darkGray

        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
    }
    
    func layout() {
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subview)
        subview.addSubview(tableView)
        view.addSubview(closeButton)
        view.addSubview(titleLB)
        NSLayoutConstraint.activate([
            
            subview.topAnchor.constraint(equalTo: titleLB.bottomAnchor, constant: 12),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            titleLB.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 9),
            titleLB.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: subview.topAnchor),
            tableView.leadingAnchor.constraint(equalTo:subview.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor),
        ])
    }
}

extension LikeForumVC: UITableViewDelegate {
    
}

extension LikeForumVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forumAricles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeForumTVCell.identifer,
                                                        for: indexPath) as? LikeForumTVCell else { fatalError("can't find Cell") }
        
        cell.postImage.layoutIfNeeded()
        cell.postImage.contentMode = .scaleAspectFill
        cell.postImage.clipsToBounds = true
        
        cell.title.text = forumAricles[indexPath.row].title
        cell.categoryBTN.setTitle(forumAricles[indexPath.row].category, for: .normal)
//        cell.seedValue.text = String(describing: forumAricles[indexPath.row].seedValue ?? 0)
        cell.talentDescription .text = forumAricles[indexPath.row].title
        
        let postUrl = forumAricles[indexPath.row].images[0]
        cell.postImage.kf.setImage(with: postUrl)
    
        return cell
        
    }
}
