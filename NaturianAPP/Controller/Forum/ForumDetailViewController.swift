//
//  ForumDetailViewController.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/16.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import SwiftUI

class ForumDetailViewController: UIViewController {
    
    var talentManager = TalentManager()
    var db: Firestore?
    
    private let tableView = UITableView()
    
    let addReplyBTN = UIButton()
    let closeButton = UIButton()
    
    var talentArticles: [TalentArticle] = []
    var userManager = UserManager()
    var userModels: [UserModel] = []
    var talentArticle: String = ""
    var searchController: UISearchController!
    
    //    var replyArray: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        style()
        layout()
        fetchTalentArticle()
        
        tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        tableView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        addReplyBTN.layer.cornerRadius = (addReplyBTN.bounds.width) / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        fetchTalentArticle()
        tableView.reloadData()
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func closePage() {
        dismiss(animated: true)
    }
    
    func fetchTalentArticle() {
        
        print(talentArticles)
        
        talentManager.fetchData { [weak self] result in
            
            switch result {
                
            case .success(let talentArticles):
                
                self?.talentArticles = talentArticles
                
                DispatchQueue.main.async {
                    
                    self?.tableView.reloadData()
                    
                }
              
            case .failure:
                
                print("can't fetch data")
            }
        }
    }
    
    func setUp() {
        
        tableView.register(ForumDetailPostTBCell.self, forCellReuseIdentifier: ForumDetailPostTBCell.identifer)
        
        tableView.register(ForumDetailReplyTBCell.self, forCellReuseIdentifier: ForumDetailReplyTBCell.identifer)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        closeButton.addTarget(self, action: #selector(closePage), for: .touchUpInside)
    }
    
    func style() {
        
        // addButton
        addReplyBTN.setTitle("", for: .normal)
        addReplyBTN.setImage(UIImage(systemName: "plus"), for: .normal)
        addReplyBTN.backgroundColor = .NaturianColor.treatmentGreen
        addReplyBTN.tintColor = .white
        // close button
        closeButton.setImage(UIImage(named: "back_white"), for: .normal)
        // tableView
        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        // tableView.bounces = false
    }
    
    func layout() {
        
        addReplyBTN.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(closeButton)
        
        view.addSubview(tableView)
//        subview.addSubview(tableView)
        tableView.addSubview(addReplyBTN)
        
        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            // addTalentButton
            addReplyBTN.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            addReplyBTN.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addReplyBTN.widthAnchor.constraint(equalToConstant: 58),
            addReplyBTN.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}

extension ForumDetailViewController: UITableViewDelegate {
    
}

extension ForumDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1 } else {
                
                return 3
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0 :
            
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: ForumDetailPostTBCell.identifer,
                                                                for: indexPath) as? ForumDetailPostTBCell else { fatalError("can't find ForumDetailPostTBCell") }
            cell1.selectionStyle = .none
            cell1.layoutIfNeeded()
            cell1.contentView.layoutIfNeeded()
            
//            .dottedLine. =
                return cell1
        case 1 :

            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: ForumDetailReplyTBCell.identifer,
                                                            for: indexPath) as? ForumDetailReplyTBCell else { fatalError("can't find ForumDetailReplyTBCell") }
            cell2.selectionStyle = .none
            return cell2
            
        default:
            
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: ForumDetailReplyTBCell.identifer,
                                                            for: indexPath) as? ForumDetailReplyTBCell else { fatalError("can't find ForumDetailReplyTBCell") }
            cell2.selectionStyle = .none
            return cell2
            
        }
    }
}
