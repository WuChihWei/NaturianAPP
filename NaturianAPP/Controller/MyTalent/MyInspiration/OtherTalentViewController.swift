//
//  OtherTalentViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/20.
//

import UIKit
import Kingfisher
import FirebaseAuth

class OtherTalentViewController: UIViewController {
    
    private let tableView = UITableView()
    
    var talentManager = TalentManager()
    var userManager = UserManager()
    var didSeletectDetails: TalentArticle!
    var userInfo: [UserModel] = []
    let subview = UIView()
    var didSelectedID: String?

    var userID = Auth.auth().currentUser?.uid
//    let userID = "2"
//    let userID = "1"
    private var appliedTalents: [TalentArticle] = []
    private var acceptTalents: [TalentArticle] = []
    
    //    var didSeletectApplierIDs: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
//        fetchAppliedTalent()
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAcceptTalent()
        fetchAppliedTalent()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.layoutIfNeeded()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appliedTalents.removeAll()
        acceptTalents.removeAll()
    }
    
    @objc func cancelApplier(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.didSelectedID = acceptTalents[indexPath?.row ?? 0].talentPostID
        talentManager.removeApplyState(applyTalentID: didSelectedID ?? "",
                                       applierID: self.userID ?? "") {[weak self] result in
            switch result {
                
            case .success:
                self?.acceptTalents.removeAll()
//                self?.fetchAppliedTalent()
                self?.tableView.reloadData()
                print("success")
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    @objc func finishAccept(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        self.didSelectedID = acceptTalents[indexPath?.row ?? 0].talentPostID
        talentManager.cancelAcceptState(applyTalentID: didSelectedID ?? "",
                                        applierID: self.userID ?? "") {[weak self] result in
            switch result {
            case .success:
                self?.acceptTalents.removeAll()
//                self?.fetchAcceptTalent()
                self?.tableView.reloadData()
                print("success")
            case .failure:
                print("can't fetch data")
            }
        }
    }
    
    func fetchAcceptTalent() {
        
        talentManager.fetchAcceptedTalent(userID: userID ?? "" ) { [weak self] result in
            
            switch result {
                
            case .success(let talentArticles):
                
                self?.acceptTalents.removeAll()
                
                self?.acceptTalents = talentArticles
                
//                self?.fetchAppliedTalent()
                
                print(self!.acceptTalents)
                
                self?.tableView.reloadData()
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
    
    func fetchAppliedTalent() {
        
        talentManager.fetchAppliedTalent(userID: userID ?? "" ) { [weak self] result in
            
            switch result {
                
            case .success(let talentArticles):
                
                self?.acceptTalents.removeAll()
                
                self?.appliedTalents = talentArticles
                
                print(self!.appliedTalents)
                
                self?.tableView.reloadData()
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
}

extension OtherTalentViewController: UITableViewDelegate {
    
}

extension OtherTalentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        for appliedTalent in appliedTalents {
            acceptTalents.append(appliedTalent)
        }
        
        return acceptTalents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        acceptTalents.merge(appliedTalents, uniquingKeysWith: +)
        
        print(appliedTalents)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InsApplingTVCell.identifer,
                                                       for: indexPath) as? InsApplingTVCell else {
            
            fatalError("can't find MyTalentAppliersTableViewCell")
            
        }
        
        let postImageURL = URL(string: acceptTalents[indexPath.row].images[0])
        cell.title.text = acceptTalents[indexPath.row].title
        cell.postImage.kf.setImage(with: postImageURL)
        cell.providerName.text = acceptTalents[indexPath.row].userInfo?.name
        cell.seedValue.text = "\(acceptTalents[indexPath.row].seedValue ?? 0)"
//        cell.talentDescription.text = appliedTalents[indexPath.row].content
        
        cell.layoutIfNeeded()
        cell.postImage.clipsToBounds = true
        cell.postImage.contentMode = .scaleAspectFill
       
        if acceptTalents[indexPath.row].didAcceptID.contains(self.userID ?? "") {
            
            cell.finishedBtn.addTarget(self, action: #selector(finishAccept(_:)), for: .touchUpInside)
            
            cell.appliedStateBtn.setImage(UIImage(named: "checked"), for: .normal)
            cell.finishedBtn.setTitle("Finished", for: .normal)
            cell.finishedBtn.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 12)
            cell.finishedBtn.setTitleColor(.white, for: .normal)
            cell.finishedBtn.backgroundColor = .NaturianColor.treatmentGreen

        } else {
            
            cell.finishedBtn.addTarget(self, action: #selector(cancelApplier(_:)), for: .touchUpInside)
            
            cell.appliedStateBtn.setImage(UIImage(named: "waiting_darkgray"), for: .normal)
            cell.finishedBtn.setTitle("Cancel", for: .normal)
            cell.finishedBtn.titleLabel?.font = UIFont(name: Roboto.bold.rawValue, size: 12)
            cell.finishedBtn.lkBorderWidth = 1.3
            cell.finishedBtn.lkBorderColor = .NaturianColor.treatmentGreen
            cell.finishedBtn.setTitleColor(.NaturianColor.treatmentGreen, for: .normal)
            cell.finishedBtn.backgroundColor = .white
        }
        
        return cell
    }
}

extension OtherTalentViewController {
    
    func setUp() {
        
        tableView.register(InsApplingTVCell.self, forCellReuseIdentifier: InsApplingTVCell.identifer)
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
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // tableView
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
