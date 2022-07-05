//
//  MyAcceptedVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/5.
//

import UIKit

class MyAcceptedVC: UIViewController {
    
    private let tableView = UITableView()
    var talentManager = TalentManager()
    
    var didSeletectDetails: TalentArticle!
    var userManager = UserManager()
    
    var talentArticleID: String?
    let subview = UIView()
    
    var userModels: [UserModel] = []
    var didSeletectApplierIDs: [String] = []
    private var acceptIDs: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAcceptInfo()        
        setUp()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        fetchUserInfo()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // fix the chat room's members, after back the room will += 1 issuee
//        userModels.removeAll()
//        appliedIDs.removeAll()
//        acceptIDs.removeAll()
    }
    
    override func viewDidLayoutSubviews() {
        
        tableView.layoutIfNeeded()
    }
    
    func setUp() {
        
        tableView.register(MyTalentAppliersTVCell.self,
                           forCellReuseIdentifier: MyTalentAppliersTVCell.identifer)
        tableView.register(MyTalentAcceptedTVCell.self,
                           forCellReuseIdentifier: MyTalentAcceptedTVCell.identifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func style() {
        
        subview.backgroundColor = .NaturianColor.lightGray
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    func layout() {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subview)
        subview.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            subview.topAnchor.constraint(equalTo: view.topAnchor),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            // tableView
            tableView.topAnchor.constraint(equalTo: subview.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0),
        ])
    }
    
    func fetchAcceptInfo() {
        
        let didAcceptIDs = didSeletectDetails.didAcceptID
    
                for didAcceptID in didAcceptIDs {
    
                    userManager.fetchUserData(userID: didAcceptID) { [weak self] result in
    
                        switch result {
    
                        case .success(let userModel):
    
                            self?.acceptIDs.append(userModel)
    
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

extension MyAcceptedVC: UITableViewDelegate {
    
}

extension MyAcceptedVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return acceptIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: MyTalentAcceptedTVCell.identifer,
                                                           for: indexPath) as? MyTalentAcceptedTVCell else {
                
                fatalError("can't find MyTalentAcceptedTVCell")
                
            }

            cell2.appliedStateBtn.setImage(UIImage(named: "checked"), for: .normal)
            cell2.acceptButton.isEnabled = false
            cell2.acceptButton.alpha = 0.3
            cell2.userName.text = acceptIDs[indexPath.row].name
            cell2.userGender.text = acceptIDs[indexPath.row].gender
            cell2.userAvatar.kf.setImage(with: acceptIDs[indexPath.row].userAvatar)
            cell2.userAvatar.lkCornerRadius = 10
            cell2.layoutIfNeeded()
            cell2.userAvatar.clipsToBounds = true
            cell2.userAvatar.contentMode = .scaleAspectFill
            
            return cell2
    }
}
