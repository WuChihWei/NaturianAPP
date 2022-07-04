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

//    var userID = Auth.auth().currentUser?.uid
    let userID = "2"

    var appliedTalents: [TalentArticle] = []
    var acceptTalents: [TalentArticle] = []

    //    var didSeletectApplierIDs: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        fetchAppliedTalent()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        appliedTalents.removeAll()
        acceptTalents.removeAll()
    }
    
    
    func setUp() {
        
        tableView.register(OtherTalentTableViewCell.self, forCellReuseIdentifier: OtherTalentTableViewCell.identifer)
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
            tableView.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: 0),
            
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
        cell.title.text = appliedTalents[indexPath.row].title
        cell.postImage.kf.setImage(with: postImageURL)
        cell.providerName.text = appliedTalents[indexPath.row].userInfo?.name
        cell.seedValue.text = "\(appliedTalents[indexPath.row].seedValue ?? 0)"
        cell.talentDescription.text = appliedTalents[indexPath.row].content
        
        cell.layoutIfNeeded()
        cell.postImage.clipsToBounds = true
        cell.postImage.contentMode = .scaleAspectFill
        
        if appliedTalents[indexPath.row].didAcceptID[0] ==
            
            userID {
            
            cell.appliedStateBtn.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            
            cell.appliedStateBtn.setImage(UIImage(named: "waiting"), for: .normal)
        }
        
        return cell
    }
}
