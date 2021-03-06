//
//  MyAppliersVC.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/5.
//

import UIKit
import FirebaseAuth
import AuthenticationServices
import Firebase

class MyAppliersVC: UIViewController {
    
    private let tableView = UITableView()
    var talentManager = TalentManager()
    var didSelectedID: String?
    
    var didSeletectDetails: TalentArticle!
    var userManager = UserManager()
    
    var userID = Auth.auth().currentUser?.uid
//            let userID = "2"
    //    let userID = "1"
    
    var talentArticleID: String?
    let subview = UIView()
    var appliedIDs: [UserModel] = []
    var myTalentInfo: TalentArticle!
    
    var userModels: [UserModel] = []
    var didSeletectApplierIDs: [String] = []
    private var subControllers: [UIViewController] = []
    
    //    var appliedIDs: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        fetchAppliedInfo()
        setUp()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appliedIDs.removeAll()
        //        fetchAppliedInfo()
        fetchMyAppliedTalent()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appliedIDs.removeAll()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        tableView.layoutIfNeeded()
    }
    
    func setUp() {
        
        tableView.register(MyTalentAppliersTVCell.self,
                           forCellReuseIdentifier: MyTalentAppliersTVCell.identifer)
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
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0)
        ])
    }
    
    @objc func cancelApplier(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.didSelectedID = appliedIDs[indexPath?.row ?? 0].userID
        talentManager.removeApplyState(applyTalentID: didSeletectDetails.talentPostID ?? "",
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
    
    @objc func applyToChat(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {
            
            fatalError("can't find ChatViewController")
        }
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        vc.chatToID = appliedIDs[indexPath?.row ?? 0].userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func acceptApplier(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.didSelectedID = appliedIDs[indexPath?.row ?? 0].userID
        
        self.appliedIDs.removeAll()
        
        talentManager.removeApplyState(applyTalentID: didSeletectDetails.talentPostID ?? "",
                                       applierID: didSelectedID ?? "") {[weak self] result in
            
            switch result {
                
            case .success:
                print("success")
                
                self?.talentManager.updateAcceptState(applyTalentID: self?.didSeletectDetails.talentPostID ?? "",
                                                      applierID: self?.didSelectedID ?? "") {[weak self] result in
                    
                    switch result {
                        
                    case .success:
                        print("success")
                        //                        var myTalentInfo =
                        //                        self?.fetchMyAppliedTalent()
                        self?.tableView.reloadData()
                        
                    case .failure:
                        print("can't fetch data")
                    }
                }
                
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    func fetchMyAppliedTalent() {
        
        talentManager.fetchMyAppliedTalent(userID: didSeletectDetails.userID ?? "",
                                           talentPostID: didSeletectDetails.talentPostID ?? "") { [weak self] result in
            switch result {
                
            case .success(let articleModel):
                
                self?.appliedIDs.removeAll()
                //                self?.acceptIDs.removeAll()
                
                self?.myTalentInfo = articleModel
                
                self?.fetchAppliedInfo()
                //                self?.fetchAcceptInfo()
                
                DispatchQueue.main.async {
                    
                    self?.tableView.reloadData()
                }
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
    
    func fetchAppliedInfo() {
        
        let didAppliedIDs = myTalentInfo.didApplyID
        
        for didAppliedID in didAppliedIDs {
            
            userManager.fetchUserData(userID: didAppliedID) { [weak self] result in
                
                switch result {
                    
                case .success(let userModel):
                    
                    self?.appliedIDs.append(userModel)
                    
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

extension MyAppliersVC: UITableViewDelegate {
    
}

extension MyAppliersVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appliedIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: MyTalentAppliersTVCell.identifer,
                                                        for: indexPath) as? MyTalentAppliersTVCell else {
            
            fatalError("can't find MyTalentAppliersTableViewCell")
            
        }
        
        cell1.appliedStateBtn.setImage(UIImage(named: "waiting_darkgray"), for: .normal)
        cell1.userName.text = appliedIDs[indexPath.row].name
        cell1.userGender.text = appliedIDs[indexPath.row].gender
        let url = URL(string: appliedIDs[indexPath.row].userAvatar ?? "")
        cell1.userAvatar.kf.setImage(with: url)
        cell1.userAvatar.lkCornerRadius = 10
        cell1.layoutIfNeeded()
        cell1.userAvatar.clipsToBounds = true
        cell1.userAvatar.contentMode = .scaleAspectFill
        cell1.acceptButton.addTarget(self, action: #selector(acceptApplier), for: .touchUpInside)
        cell1.cancelButton.addTarget(self, action: #selector(cancelApplier), for: .touchUpInside)
        cell1.chatButton.addTarget(self, action: #selector(applyToChat(_:)), for: .touchUpInside)
        
        return cell1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {
            
            fatalError("can't find ChatViewController")
        }
        
        vc.chatToID = appliedIDs[indexPath.row].userID
        //        vc.chatTalentID = self.talentArticleID ?? ""
        //        vc.user2UID = self.userModels[indexPath.row].userID
        //        vc.chatToTalentModel = didSeletectDetails
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
