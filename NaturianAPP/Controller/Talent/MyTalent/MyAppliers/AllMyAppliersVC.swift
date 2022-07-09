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
    
    var didSelectedID: String?
    var didSelectedPost: String?
    
    private var appliedIDs: [UserModel] = []
    private var acceptIDs: [UserModel] = []
    
    var myTalentInfo: TalentArticle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        appliedIDs.removeAll()
        acceptIDs.removeAll()
        fetchMyAppliedTalent()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        
        tableView.layoutIfNeeded()
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
    
    @objc func cancelAccept(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.didSelectedID = acceptIDs[indexPath?.row ?? 0].userID
        talentManager.cancelAcceptState(applyTalentID: didSeletectDetails.talentPostID ?? "",
                                       applierID: didSelectedID ?? "") {[weak self] result in
            switch result {
            case .success:
                self?.tableView.reloadData()
                print("success")
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    @objc func cancelApplier(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.didSelectedID = appliedIDs[indexPath?.row ?? 0].userID
        talentManager.removeApplyState(applyTalentID: didSeletectDetails.talentPostID ?? "",
                                       applierID: didSelectedID ?? "") {[weak self] result in
            switch result {
                
            case .success:
                
                self?.tableView.reloadData()
                print("success")
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    @objc func acceptApplier(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.didSelectedID = appliedIDs[indexPath?.row ?? 0].userID
        talentManager.removeApplyState(applyTalentID: didSeletectDetails.talentPostID ?? "", applierID: didSelectedID ?? "") {[weak self] result in
            
            switch result {
                
            case .success:
                print("success")
                
                self?.talentManager.updateAcceptState(applyTalentID: self?.didSeletectDetails.talentPostID ?? "",
                                                      applierID: self?.didSelectedID ?? "") {[weak self] result in
                    
                    switch result {
                        
                    case .success:
                        print("success")
                        //
                        self?.appliedIDs.removeAll()
                        self?.acceptIDs.removeAll()
                        //                        var myTalentInfo =
                        self?.fetchMyAppliedTalent()
                        print(self?.acceptIDs ?? [])
                        
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
                
                self?.myTalentInfo = articleModel
                
                self?.fetchAppliedInfo()
                self?.fetchAcceptInfo()
                
                print(self?.myTalentInfo as Any)
                
                DispatchQueue.main.async {
                                    
                    self?.tableView.reloadData()
                }
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
    
    func fetchAppliedInfo() {
        
        for didAppliedID in myTalentInfo.didApplyID {
            
            userManager.fetchUserData(userID: didAppliedID) { [weak self] result in
                
                switch result {
                    
                case .success(let userModel):
                    
                    self?.appliedIDs.append(userModel)
                    
                    print(self?.userModels as Any)
                    
                    DispatchQueue.main.async {
                        
                        print(self?.appliedIDs)
                        
                        self?.tableView.reloadData()
                    }
                    
                case .failure:
                    
                    print("can't fetch data")
                }
            }
        }
    }
    
    func fetchAcceptInfo() {
        
        for didAcceptID in myTalentInfo.didAcceptID {
            
            userManager.fetchUserData(userID: didAcceptID) { [weak self] result in
                
                switch result {
                    
                case .success(let userModel):
                    
                    self?.acceptIDs.append(userModel)
                    
                    print(self?.userModels as Any)
                    //
                    DispatchQueue.main.async {
                        
                        print(self?.acceptIDs)
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
            cell1.acceptButton.addTarget(self, action: #selector(acceptApplier), for: .touchUpInside)
            cell1.cancelButton.addTarget(self, action: #selector(cancelApplier), for: .touchUpInside)
            cell1.chatButton.addTarget(self, action: #selector(applyToChat(_:)), for: .touchUpInside)
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
            cell2.cancelButton.addTarget(self, action: #selector(cancelAccept), for: .touchUpInside)
            cell2.chatButton.addTarget(self, action: #selector(accpetToChat(_:)), for: .touchUpInside)
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ChatViewController") as? ChatViewController else {
            
            fatalError("can't find ChatViewController")
        }
        
        vc.chatToID = acceptIDs[indexPath.row].userID
        vc.chatToID = appliedIDs[indexPath.row].userID
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension AllMyAppliersVC {
    
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
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0)
        ])
    }
}
