//
//  MyChatRoomVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/5.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth // 用來與 Firebase Auth 進行串接用的


class MyChatRoomVC: UIViewController {

//    var talentManager = TalentManager()
    var userManager = UserManager()
    var chatManager = ChatManager()
    var userModels: [UserModel] = []

    var forumManager = ForumManager()
    
//    let closeButton = UIButton()
    let titleLB = UILabel()
    
        let userID = Auth.auth().currentUser?.uid
//    let userID = "2"
//    let userID = "1"
    private var chatModels: [ChatModel] = []
    var newChatModels: [String] = []
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tabBarController?.tabBar.isHidden = true
        setUp()
        style()
        layout()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        navigationController?.navigationBar.isHidden = true
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        fetchChatInfo()
//        fetchBlockInfo()
//        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newChatModels.removeAll()
        userModels.removeAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        newChatModels.removeAll()
        userModels.removeAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func closePage() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: false)
    }

    func fetchChatInfo() {
        
        chatManager.fetchChatData(userID: userID ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let ChatModels):
                
                self?.chatModels = ChatModels
           
                for chatModel in self!.chatModels {
                    
                    let new = chatModel.users.filter { $0 != self?.userID }
                    
                    print(new[0])
                    
                    self?.newChatModels.append(new[0])
                }
                                
                for user in self!.newChatModels {

                    self?.userManager.fetchUserData(userID: user) { [weak self] result in

                        switch result {

                        case .success(let userModel):

                            self?.userModels.append(userModel)

                            print(self?.userModels as Any)

                            DispatchQueue.main.async {

                                self?.tableView.reloadData()
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

    func setUp() {
        
//        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        
        tableView.register(ChatRoomTVCell.self, forCellReuseIdentifier: ChatRoomTVCell.identifer)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func style() {
        
//        closeButton.setImage(UIImage(named: "back_gray"), for: .normal)
//
        titleLB.text = "Chat Room"
        titleLB.font = UIFont(name: Roboto.bold.rawValue, size: 20)
        
        tableView.backgroundColor = .NaturianColor.lightGray
        tableView.lkBorderWidth = 1
        tableView.lkBorderColor = .NaturianColor.darkGray

        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
    }
    
    func layout() {
        
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
//        view.addSubview(closeButton)
        view.addSubview(titleLB)
        
        NSLayoutConstraint.activate([
            
//            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
//            closeButton.heightAnchor.constraint(equalToConstant: 36),
//            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            titleLB.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 33),
            titleLB.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLB.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MyChatRoomVC: UITableViewDelegate {
    
}

extension MyChatRoomVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTVCell.identifer,
                                                        for: indexPath) as? ChatRoomTVCell else { fatalError("can't find Cell") }
        
        cell.nameLabel.text = userModels[indexPath.row].name

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let blockID = blockUserIDs[indexPath.row].userID ?? ""
//
//        self.userManager.removeBlockList(uid: self.userID ?? "", blockID: blockID) { [weak self] result in
//            switch result {
//
//            case .success:
//
//                self?.blockUserIDs.removeAll()
//                self?.userState()
//                self?.tableView.reloadData()
//
//            case .failure:
//                print("can't fetch data")

//            }
//        }
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {

            fatalError("can't find ChatViewController")
        }
      
        vc.chatToID = userModels[indexPath.row].userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
