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
    
    var userID = Auth.auth().currentUser?.uid
//    let userID = "2"

    var appliedTalents: [TalentArticle] = []
    var acceptTalents: [TalentArticle] = []

    //    var didSeletectApplierIDs: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        fetchAppliedTalent()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      fetchAcceptTalent()
        fetchAppliedTalent()
        tableView.reloadData()
    }
    
    func setUp() {
        
        tableView.register(OtherTalentTableViewCell.self, forCellReuseIdentifier: OtherTalentTableViewCell.identifer)
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
    
    func fetchAcceptTalent() {
        
        talentManager.fetchAcceptedTalent(userID: userID ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let talentArticles):
                
                self?.acceptTalents = talentArticles
                
                print(self!.acceptTalents)
                
                self?.tableView.reloadData()
                
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
    
    func fetchAppliedTalent() {
        
        talentManager.fetchAppliedTalent(userID: userID ?? "") { [weak self] result in
            
            switch result {
                
            case .success(let talentArticles):
                
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
        
        for acceptTalent in acceptTalents {
            appliedTalents.append(acceptTalent)
        }
        
        return appliedTalents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        acceptTalents.merge(appliedTalents, uniquingKeysWith: +)
    
        print(appliedTalents)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherTalentTableViewCell.identifer,
                                                       for: indexPath) as? OtherTalentTableViewCell else {
            
            fatalError("can't find MyTalentAppliersTableViewCell")
            
        }
        
        let postImageURL = appliedTalents[indexPath.row].images[0]
        cell.talentTitle.text = appliedTalents[indexPath.row].title
        cell.postImage.kf.setImage(with: postImageURL)
        
        
        if appliedTalents[indexPath.row].didAcceptID[0] ==
            
            userID {
            
            cell.appliedStateBtn.setImage(UIImage(named: "check"), for: .normal)
        } else {
            
            cell.appliedStateBtn.setImage(UIImage(named: "pending"), for: .normal)
        }
        
        return cell
    }
}
