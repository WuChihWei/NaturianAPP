//
//  TalentAppliersViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class MyTalentAppliersVC: UIViewController {
    
    private let tableView = UITableView()
    var talentManager = TalentManager()
    
    var didSeletectDetails: TalentArticle!
    var userManager = UserManager()
    
    var talentArticleID: String?
    
    var userModels: [UserModel] = []
    var didSeletectApplierIDs: [String] = []
    //    var newUserModel: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        //                fetchUserInfo()
        
        //        DispatchQueue.main.async {
        //                        self.fetchUserInfo()
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchUserInfo()
        tableView.reloadData()
        
    }
    override func viewDidLayoutSubviews() {
        
        tableView.layoutIfNeeded()
    }
    
    func setUp() {
        
        tableView.register(MyTalentAppliersTableViewCell.self,
                           forCellReuseIdentifier: MyTalentAppliersTableViewCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func style() {
        
        tableView.separatorStyle = .none
    }
    
    func layout() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // tableView
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    func fetchUserInfo() {
        
        for didSeletectApplier in didSeletectApplierIDs {
            
            userManager.fetchUserData(userID: didSeletectApplier ) {
                
                [weak self] result in
                
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
    }
}

extension MyTalentAppliersVC: UITableViewDelegate {
    
}

extension MyTalentAppliersVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTalentAppliersTableViewCell.identifer,
                                                       for: indexPath) as? MyTalentAppliersTableViewCell else {
            
            fatalError("can't find MyTalentAppliersTableViewCell")
            
        }
        
        let photoUrl = userModels[indexPath.row].userAvatar
        
        cell.userName.text = userModels[indexPath.row].name

        cell.userAvatar.kf.setImage(with: photoUrl)
        
        cell.layoutIfNeeded()
        
        cell.userAvatar.lkCornerRadius = cell.userAvatar.frame.width / 2
        cell.userAvatar.clipsToBounds = true
        cell.userAvatar.contentMode = .scaleAspectFill
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {

            fatalError("can't find ChatViewController")
        }
        
        vc.chatTalentID = self.talentArticleID ?? ""
        vc.currentUser = self.userModels[indexPath.row].userID
 
        self.navigationController?.pushViewController(vc, animated: true)
                
    }
}
