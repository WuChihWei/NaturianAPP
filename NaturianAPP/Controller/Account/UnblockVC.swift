//
//  UnblockVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/10.
//

import UIKit
import Kingfisher
import FirebaseAuth
import AuthenticationServices

class UnblockVC: UIViewController {
    
    var talentManager = TalentManager()
    var userManager = UserManager()

    var forumManager = ForumManager()
    
    let closeButton = UIButton()
    let titleLB = UILabel()
    
    //    let userID = Auth.auth().currentUser?.uid
    let userID = "2"
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

        userState()
//        fetchBlockInfo()
//        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func closePage() {
        navigationController?.popViewController(animated: false)
    }
    
    func userState() {
                    
            userManager.fetchUserData(userID: userID) { [weak self] result in
                
                switch result {
                    
                case .success(let userModel):
                    
                    self?.userModels = userModel
                    self?.fetchBlockInfo()
                    
                    DispatchQueue.main.async {
                        
                        self?.viewDidLoad()
                    }
                    
                case .failure:
                    print("can't fetch data")
                }
            }
        }
    
    func fetchBlockInfo() {
        
        for user in userModels.blockList {
            
            userManager.fetchUserData(userID: user) { [weak self] result in
                
                switch result {
                    
                case .success(let userModel):
                    
                    self?.blockUserIDs.append(userModel)
                    
                    print(self?.userModels as Any)
                    
                    DispatchQueue.main.async {
                        
                        print(self?.blockUserIDs)
                        
                        self?.tableView.reloadData()
                    }
                    
                case .failure:
                    
                    print("can't fetch data")
                }
            }
        }
    }
    
    
    func setUp() {
        
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        
        tableView.register(UnblockTVCell.self, forCellReuseIdentifier: UnblockTVCell.identifer)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func style() {
        
        closeButton.setImage(UIImage(named: "back_gray"), for: .normal)
        
        titleLB.text = "Unblock Users"
        titleLB.font = UIFont(name: Roboto.bold.rawValue, size: 20)
        
        tableView.backgroundColor = .NaturianColor.lightGray
        tableView.lkBorderWidth = 1
        tableView.lkBorderColor = .NaturianColor.darkGray

        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
    }
    
    func layout() {
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLB.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(closeButton)
        view.addSubview(titleLB)
        
        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            titleLB.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 9),
            titleLB.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLB.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension UnblockVC: UITableViewDelegate {
    
}

extension UnblockVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return blockUserIDs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UnblockTVCell.identifer,
                                                        for: indexPath) as? UnblockTVCell else { fatalError("can't find Cell") }
        
        cell.nameLabel.text = blockUserIDs[indexPath.row].name

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let blockID = blockUserIDs[indexPath.row].userID ?? ""
        
        self.userManager.removeBlockList(uid: self.userID ?? "", blockID: blockID) { [weak self] result in
            switch result {
                
            case .success:
                
                self?.blockUserIDs.removeAll()
                self?.userState()
                self?.tableView.reloadData()
                
            case .failure:
                print("can't fetch data")
                
            }
        }
    }
    
}
