//
//  MyAcceptedVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/5.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import Firebase

class MyAcceptedVC: UIViewController {
    
    private let tableView = UITableView()
    var talentManager = TalentManager()
    
    var didSeletectDetails: TalentArticle!
    var userManager = UserManager()
    
    var userID = Auth.auth().currentUser?.uid
//    let userID = "2"
    //    let userID = "1"
    
    var talentArticleID: String?
    let subview = UIView()
    var myTalentInfo: TalentArticle!
    
    var didSeletectApplierIDs: [String] = []
    var acceptIDs: [UserModel] = []
    var didSelectedID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        fetchAcceptInfo()
        setUp()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        acceptIDs.removeAll()
        //        fetchAcceptInfo()
        fetchMyAppliedTalent()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        acceptIDs.removeAll()
    }
    
    override func viewDidLayoutSubviews() {
        
        tableView.layoutIfNeeded()
    }
    
    func setUp() {
        
        //        tableView.register(MyTalentAppliersTVCell.self,
        //                           forCellReuseIdentifier: MyTalentAppliersTVCell.identifer)
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
    
    @objc func cancelAccept(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.didSelectedID = acceptIDs[indexPath?.row ?? 0].userID
        talentManager.cancelAcceptState(applyTalentID: didSeletectDetails.talentPostID ?? "",
                                        applierID: didSelectedID ?? "") {[weak self] result in
            switch result {
            case .success:
                self?.fetchMyAppliedTalent()
                self?.tableView.reloadData()
                print("success")
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    @objc func accpetToChat(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {
            
            fatalError("can't find ChatViewController")
        }
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        vc.chatToID = acceptIDs[indexPath?.row ?? 0].userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchMyAppliedTalent() {
        talentManager.fetchMyAppliedTalent(userID: didSeletectDetails.userID ?? "",
                                           talentPostID: didSeletectDetails.talentPostID ?? "") { [weak self] result in
            switch result {
                
            case .success(let articleModel):
                
                self?.myTalentInfo = articleModel
                
                self?.fetchAcceptInfo()
                
                DispatchQueue.main.async {
                    
                    self?.tableView.reloadData()
                }
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
    
    func fetchAcceptInfo() {
        
        let didAcceptIDs = myTalentInfo.didAcceptID
        
        for didAcceptID in didAcceptIDs {
            
            userManager.fetchUserData(userID: didAcceptID) { [weak self] result in
                
                switch result {
                    
                case .success(let userModel):
                    
                    self?.acceptIDs.append(userModel)
                    
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
        let url = URL(string: acceptIDs[indexPath.row].userAvatar ?? "")
        cell2.userAvatar.kf.setImage(with: url)
        cell2.userAvatar.lkCornerRadius = 10
        cell2.layoutIfNeeded()
        cell2.userAvatar.clipsToBounds = true
        cell2.userAvatar.contentMode = .scaleAspectFill
        cell2.cancelButton.addTarget(self, action: #selector(cancelAccept), for: .touchUpInside)
        cell2.chatButton.addTarget(self, action: #selector(accpetToChat(_:)), for: .touchUpInside)
        
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {
            
            fatalError("can't find ChatViewController")
        }
        
        vc.chatToID = acceptIDs[indexPath.row].userID
        //        vc.chatTalentID = self.talentArticleID ?? ""
        //        vc.user2UID = self.userModels[indexPath.row].userID
        //        vc.chatToTalentModel = didSeletectDetails
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
