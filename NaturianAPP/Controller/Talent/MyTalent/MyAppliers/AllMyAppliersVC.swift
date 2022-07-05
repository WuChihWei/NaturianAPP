//
//  AllMyAppliersVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/5.
//

import UIKit

class AllMyAppliersVC: UIViewController {
    
    private let tableView = UITableView()
    var talentManager = TalentManager()
    
    var didSeletectDetails: TalentArticle!
    var userManager = UserManager()
    
    var talentArticleID: String?
    //    var userID = Auth.auth().currentUser?.uid
    let userID = "2"
    let subview = UIView()
    
    var userModels: [UserModel] = []
    var didSeletectApplierIDs: [String] = []
    
    private var appliedIDs: [UserModel] = []
    private var acceptIDs: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAppliedInfo()
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

    func fetchAppliedInfo() {
        
        let didAppliedIDs = didSeletectDetails.didApplyID
    
                for didAppliedID in didAppliedIDs {
    
                    userManager.fetchUserData(userID: didAppliedID) { [weak self] result in
    
                        switch result {
    
                        case .success(let userModel):
    
                            self?.appliedIDs.append(userModel)
    
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

extension AllMyAppliersVC: UITableViewDelegate {
    
}

extension AllMyAppliersVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return appliedIDs.count
            
        } else if section == 1 {
            
            return acceptIDs.count
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: MyTalentAppliersTVCell.identifer,
                                                           for: indexPath) as? MyTalentAppliersTVCell else {
                
                fatalError("can't find MyTalentAppliersTableViewCell")
                
            }
            
            cell1.appliedStateBtn.setImage(UIImage(named: "waiting_darkgray"), for: .normal)
            cell1.userName.text = appliedIDs[indexPath.row].name
            cell1.userGender.text = appliedIDs[indexPath.row].gender
            cell1.userAvatar.kf.setImage(with: appliedIDs[indexPath.row].userAvatar)
            cell1.userAvatar.lkCornerRadius = 10
            cell1.layoutIfNeeded()
            cell1.userAvatar.clipsToBounds = true
            cell1.userAvatar.contentMode = .scaleAspectFill
            
            return cell1
            
        } else {
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {
            
            fatalError("can't find ChatViewController")
        }
        
        //        vc.chatTalentID = self.talentArticleID ?? ""
        //        vc.user2UID = self.userModels[indexPath.row].userID
        vc.chatToTalentModel = didSeletectDetails
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
